# == Schema Information
#
# Table name: import_entries
#
#  id                    :integer          not null, primary key
#  target_model_cd       :integer
#  source_id             :integer
#  target_id             :integer
#  import_source_file_id :integer
#  data                  :text             not null
#  state                 :string(255)      default("new"), not null
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Import::Entry < ActiveRecord::Base

  STATE_VALUES = {:new => 1, :prepared => 3, :flagged => 10, :imported => 10}

	#associations
  belongs_to :source_file, class_name: 'Import::SourceFile', foreign_key: 'import_source_file_id', :inverse_of => :entries
  has_many :failures, class_name: 'Import::Failure', foreign_key: 'import_entry_id'

  #persisted attributes
  attr_accessible :data, :source_id, :target_id, :target_model, :source_file, :failures

	as_enum :target_model, user: 0, artist: 1, music_label: 2
	serialize :data

	#validations
	validates_as_enum :target_model, :allow_nil => true
	validates_presence_of :data, :state, :import_source_file_id
  validates_presence_of :target_model, :source_id, :if => :prepared?

  #scopes
  scope :at_state, lambda {|state_name| where(:state => state_name.to_s) }
  scope :of_type, lambda {|target_model| where(:target_model_cd => self.target_models[target_model]) }

	#state machine
  state_machine :initial => :new do
  	before_transition :on => :auto_discover, :do => :discover
    before_transition :on => :async_import, :do => :schedule_import
    before_transition :on => :import, :do => :bg_import
    before_transition :on => :update_data, :do => :update_data_and_clear_failures

    around_transition do |entry, transition, block|
      entry.with_lock do
        block.call
      end
    end

    after_failure do |entry, transition|
      Rails.logger.info "a failure occured on transition : #{transition.inspect}"
      entry.errors.full_messages.each do |msg|
        Import::Failure.new(description: msg, entry: entry).save!
      end
    end

    event :auto_discover do
    	transition :new => :prepared
    end
    event :update_data do
      transition :new => same
    end
    event :async_import do
      transition :prepared => :flagged
    end
    event :import do
      transition :flagged => :imported
    end
    event :refresh_status do
      transition :flagged => :prepared, :if => :has_failures?
      transition :imported => :imported
      transition all => same
    end
  end

  def self_import
    ENV['WORK_AROUND_ASYNC'].nil? ? async_import : test_import
  end

  private

    def test_import
      async_import
      do_import
    end

    def has_failures?
      !failures.empty?
    end

    def dependencies
      @dependencies || {}
    end

    def update_data_and_clear_failures(transition)
      new_data = transition.args[0]
      begin
        h = HashWithIndifferentAccess.new(eval(new_data))
        self.transaction do
          update_attributes({:data => h}) && failures.destroy_all
        end
      rescue Exception
        errors.add :data, :is_not_a_hash
        return false
      end
    end

    def schedule_import
      reload.delay(:queue => 'import_engine').do_import if ENV['WORK_AROUND_ASYNC'].nil?
    end

    def do_import
      @dependencies = get_dependencies()
      import()
      refresh_status()
    end

    def bg_import
      send "import_as_#{target_model}"
    end

    def update_entry_target_id(object)
      if object.persisted?
        update_attributes!(:target_id => object.id)
      else
        #in case of failure, transfer object errors to entries
        object.errors.full_messages.each do |msg|
          errors.add(:base, msg)
        end
      end
    end

    def retrieve_dependency_id(model, source)
      target_model_code = Import::Entry.target_models(model)

      raise ArgumentError.new("'#{model}' is not a valid target model") if target_model_code.nil?
      raise ArgumentError.new("source must be a non-null integer") unless (source.is_a?(Integer) && source > 0)

      dependency = Import::Entry.where(:target_model_cd => target_model_code, :import_source_file_id => import_source_file_id, :source_id => source).first
      raise "there is no entry of type '#{target_model}' with source id '#{source_id}'" if dependency.nil?

      return dependency.target_id unless dependency.target_id.nil?

      #entry is not planned to be imported => do it
      unless dependency.flagged?
        unless dependency.with_lock { dependency.self_import }
          raise "Impossible to start entry##{dependency.id}(#{model}##{source}) import"
        end
      end

      # for testing purposes : cutting the asynchronysm makes the target_id available
      unless ENV['WORK_AROUND_ASYNC'].nil?
        return dependency.target_id
      end

      raise Exceptions::ImportDependencyException.new("entry##{dependency.id}(#{model}##{source}) dependency import is in progress for entry##{id}(#{target_model}##{source_id})")
    end
end