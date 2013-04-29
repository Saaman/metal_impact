PRNG ||= Random.new()

FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.words.join(" ") }
  sequence(:random_text) { |n| Faker::Lorem.paragraphs.join("\n") }

  factory :user, aliases: [:whodunnit, :reviewer] do
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:pseudo) { |n| "person_#{n}" }
    password "foobar1"
    email_confirmation { email }

    after(:create) { |user, evaluator| user.confirm! }
  end

  #create an artist. This will be a band by default, give a practice_kind to change
  factory :artist do
    ignore do
      practice_kind :band
    end

    name { generate(:random_string) }
    practices { [Practice.find_by_kind(practice_kind)] }
    countries ["FR"]
    published true
  end

  factory :album do
    title { generate(:random_string) }
    release_date { 1.month.ago.to_date }
    published true

    kind :album

    trait :with_cover do
      cover { File.open(File.join([uploaders_fixtures_path, 'test_img.png'])) }
    end

    trait :with_artists do
      after(:build) { |album| album.artists = FactoryGirl.create_list(:artist, PRNG.rand(1..2), albums: [album]) }
    end

    trait :with_music_genre do
      after(:build) { |album| album.music_genre = FactoryGirl.create(:music_genre) }
    end

    factory :album_with_artists,            traits: [:with_artists]
    factory :album_with_cover,              traits: [:with_cover]
    factory :album_with_artists_and_cover,  traits: [:with_artists, :with_cover]
  end


  factory :music_label do
    name { generate(:random_string) }
    website { "http://www.#{Faker::Internet.domain_name}" }
    distributor { generate(:random_string) }
  end

  factory :source_file, :class => Import::SourceFile do
    path { File.join([Rails.root] + Faker::Lorem.words + ["toto.yml"]) }

    trait :ready do
      source_type { :metal_impact}
    end

    trait :with_entries do
      after(:create) { |source_file| source_file.entries = FactoryGirl.create_list(:entry, PRNG.rand(2..10), source_file: source_file) }
    end
    trait :with_failed_entries do
      after(:create) { |source_file| source_file.entries = FactoryGirl.create_list(:entry, PRNG.rand(2..10), :with_failures, source_file: source_file) }
    end
    trait :with_discovered_entries do
      after(:create) { |source_file| source_file.entries = FactoryGirl.create_list(:entry, PRNG.rand(2..10), :discovered, state: 'prepared', source_file: source_file) }
    end
  end

  factory :entry, :class => Import::Entry do
    data { {"toto" => generate(:random_string), "tata" => 21} }
    source_file

    trait :discovered do
      target_model { :user }
      source_id { 1 }
    end

    trait :with_failures do
      after(:create) { |entry| entry.failures = FactoryGirl.create_list(:failure, PRNG.rand(1..3), entry: entry) }
    end

    factory :metal_impact_entry, :class => Import::MetalImpactEntry do
      data { {id: 2, model: 'user' } }

      factory :metal_impact_user do
        data { {id: 2, model: 'user', pseudo: 'Seth F.', email: 'seth_f.staff@metal-impact.com', password: 'SethF.2', created_at: '12/04/2007 16:57:36', updated_at: '12/04/2007 16:57:36', :role => :staff } }

        factory :discovered_metal_impact_user do
          target_model { :user }
          source_id { 2 }
          state { 'prepared' }
        end
      end
      factory :metal_impact_artist do
        data { { id: 1, model: 'artist', name: 'NINE INCH NAILS', countries: ['US'], created_at: '12/04/2007 16:57:36', updated_at: '12/04/2007 16:57:36', created_by: 2 } }
        factory :discovered_metal_impact_artist do
          target_model { :artist }
          source_id { 1 }
          state { 'prepared' }
        end
      end
    end
  end

  factory :failure, :class => Import::Failure do
    description { generate(:random_string) }
    entry
  end

  factory :contribution do
    ignore do
      my_object { FactoryGirl.create(:artist) }
    end
    draft_object { HashWithIndifferentAccess.new(my_object.attributes) }
    approvable { my_object }
    event :create
    whodunnit
  end

  factory :style_alteration, :class => MusicGenre::StyleAlteration do
    keyword { generate(:random_string) }
  end
  factory :main_style, :class => MusicGenre::MainStyle do
    keyword { generate(:random_string) }
  end
  factory :music_type, :class => MusicGenre::MusicType do
    keyword { generate(:random_string) }
  end
  factory :music_genre do
    name { generate :random_string }
    after(:build) { |music_genre| music_genre.music_types = FactoryGirl.create_list(:music_type, PRNG.rand(1..2)) }
  end

  factory :review do
    body { generate(:random_text) }
    score { PRNG.rand(0..10) }
    reviewer
    product { FactoryGirl.create :album_with_artists }
    trait :published do
      published true
    end
  end
end
