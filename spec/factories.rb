PRNG ||= Random.new()

FactoryGirl.define do

  sequence(:random_string) { |n| Faker::Lorem.words.join(" ") }

  factory :user, aliases: [:creator, :updater] do
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
    creator
    updater
  end

  factory :album do
    title { generate(:random_string) }
    release_date { 1.month.ago.to_date }
    published true
    creator
    updater

    kind :album

    trait :with_cover do
      cover { File.open(File.join([uploaders_fixtures_path, 'test_img.png'])) }
    end

    trait :with_artists do
      after(:build) { |album| album.artists = FactoryGirl.create_list(:artist, PRNG.rand(1..2), albums: [album]) }
    end

    factory :album_with_artists,            traits: [:with_artists]
    factory :album_with_cover,              traits: [:with_cover]
    factory :album_with_artists_and_cover,  traits: [:with_artists, :with_cover]
  end


  factory :music_label do
    name { generate(:random_string) }
    website { "http://www.#{Faker::Internet.domain_name}" }
    distributor { generate(:random_string) }
    creator
    updater
  end

  factory :source_file, :class => Import::SourceFile do
    path { File.join([Rails.root] + Faker::Lorem.words + ["toto.yml"]) }
  end

  factory :entry, :class => Import::Entry do
    data { {"toto" => generate(:random_string), "tata" => 21} }
    source_file

    trait :discovered do
      target_model { :user }
      source_id { 1 }
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
end