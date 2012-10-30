#start test coverage
require 'simplecov'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'paperclip/matchers'

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
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  #insert devise support
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

  #alias it_behaves_like
  config.alias_it_should_behave_like_to :its_access_is, 'access is'

  #include paperclip matchers
  config.include Paperclip::Shoulda::Matchers

  #Configure Selenium web driver
  require 'selenium-webdriver'
  Capybara.register_driver :selenium do |app|
    proxy = Selenium::WebDriver::Proxy.new(:http => ENV['HTTP_PROXY'] || ENV['http_proxy'])
    ENV['HTTP_PROXY'] = ENV['http_proxy'] = nil
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["intl.accept_languages"] =  "fr-FR"
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :proxy => proxy, profile: profile)
  end

  config.before(:suite) do
    #Erase all existing records
    Approval.delete_all
    Album.delete_all
    Artist.delete_all
    Practice.delete_all
    MusicLabel.delete_all
    User.delete_all

    #Insert the necessary data
    Practice.kinds.each_key do |key|
      Practice.create! kind: key
    end
  end
end