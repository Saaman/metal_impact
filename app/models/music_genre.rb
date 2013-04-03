class MusicGenre < ActiveRecord::Base
  attr_accessible :name
  attr_readonly :computed_name

  translates :name

  #associations
  has_and_belongs_to_many_with_deferred_save :music_types, class_name: MusicGenre::MusicType, join_table: 'music_genre_components_music_genres', :association_foreign_key => 'mg_component_id'

  has_and_belongs_to_many_with_deferred_save :main_styles, class_name: MusicGenre::MainStyle, join_table: 'music_genre_components_music_genres', :association_foreign_key => 'mg_component_id'

  has_and_belongs_to_many_with_deferred_save :style_alterations, class_name: MusicGenre::StyleAlteration, join_table: 'music_genre_components_music_genres', :association_foreign_key => 'mg_component_id'

  #validations
  validates :name, presence: true
  validates :computed_name, presence: true, uniqueness: { case_sensitive: false }
  validates :music_types, presence: true, length: { :in => 1..2 }
  validates :main_styles, length: { :in => 0..2 }
  validates :style_alterations, length: { :in => 0..2 }

  before_validation :name_it

  protected
  def name_it
  	part_one = self.main_styles.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
  	part_two = self.music_types.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
  	part_three = self.style_alterations.sort{|x, y| x.id <=> y.id}.collect{|x| x.keyword}.join('/')
    self.computed_name = "#{part_one} #{part_two} #{part_three}"
  end
end
