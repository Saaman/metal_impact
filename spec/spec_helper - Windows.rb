#start test coverage
require 'simplecov'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

#disable routing filters
RoutingFilter.active = false

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.order = "default"

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  #insert devise support
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros

  #alias it_behaves_like
  config.alias_it_should_behave_like_to :its_access_is, 'access is'

  #change capybara javascript driver
  Capybara.javascript_driver = :webkit
  Capybara.default_wait_time = 30


  #Database cleaning
  config.before(:suite) do
    DatabaseCleaner.clean_with :deletion
    #Insert the necessary data
    Practice.kinds.each_key do |key|
      Practice.create! kind: key
    end
  end

  config.before :each do
    if Capybara.current_driver == :webkit
      DatabaseCleaner.strategy = :deletion, { :except => %w[practices] }
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end