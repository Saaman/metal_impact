# == Schema Information
#
# Table name: reviews
#
#  id           :integer          not null, primary key
#  product_id   :integer
#  product_type :string(255)
#  score        :integer
#  reviewer_id  :integer
#  published    :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Review < ActiveRecord::Base
	#behavior
	include Contributable

	#associations
  belongs_to :product, :polymorphic => true
  belongs_to :reviewer, :class_name => "User"

  attr_accessible :score, :body, :product_id, :product_type

  translates :body

  #validation
  validates :product, :reviewer, :body, :score, presence: true
  validates :score, :numericality => { :less_than_or_equal_to => 10, :greater_than_or_equal_to => 0, :only_integer => true }
  validates :reviewer_id, :uniqueness => { :scope => [:product_id, :product_type]}

  validate :product_must_be_productable

  private
    def product_must_be_productable
      if !product.nil? and !(product.is_a? Productable)
        errors.add :product, :is_not_productable
      end
    end
end
