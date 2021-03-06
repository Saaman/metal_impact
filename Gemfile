source 'http://rubygems.org'

#Core gems
gem 'rails', '~> 3.2.5'
gem 'railties', '~> 3.2.5'
gem 'thin', '~> 1.5.0'
gem 'pg', '~> 0.14.1'

#User & Rights gems
gem 'devise', '~> 2.1.2'
gem 'cancan', '~> 1.6.8'
gem 'public_activity', '~> 1.0.2'

#cache
gem 'memcachier', '~> 0.0.2'
gem 'dalli', '~> 2.6.2'

#Model stuff gems
gem 'foreigner', '~> 1.2.1'
gem 'validates_timeliness', '~> 3.0.12'
gem 'simple_enum', '~> 1.6.1'
gem 'globalize3', '~>0.2.0'
gem 'state_machine', '~>1.1.2'
gem 'deferred_associations', '~>0.5.4'

#image uploads management
gem 'mini_magick', '~> 3.4.0'
gem 'carrierwave', '~> 0.7.0'

#UI gems
gem 'webshims-rails', '~> 0.4.4'
gem 'jquery-rails', '~> 2.1.0'
gem 'anjlab-bootstrap-rails', '~> 2.2.1.2', :require => 'bootstrap-rails'
gem 'bootstrap-will_paginate', '~> 0.0.9'
gem 'will_paginate', '~> 3.0.3'
gem 'recaptcha', :require => 'recaptcha/rails', :git => "https://github.com/ambethia/recaptcha.git"
gem 'simple_form', '~> 2.0.2'


#Async engine
gem 'delayed_job_active_record', '~>0.3.3'
gem 'devise-async', '~>0.4.0'
gem 'daemons', '~>1.1.9'
gem 'dj_mon', '~>1.1.0'

# I18n
gem 'devise-i18n', '~> 0.5.11'
gem 'rails-i18n', '~> 0.7.0'
gem 'will-paginate-i18n', '~> 0.1.11'
gem 'i18n-js', '~> 2.1.2'
gem 'i18n_country_select', '~>1.0.12'

#others
gem 'http_accept_language', '~> 1.0.2'
gem 'squeel', '~>1.0.13'
gem 'routing-filter', '~>0.3.1' #used for url filtering on languages codes
gem 'turnout', '~>0.2.2' #maintenance mode gem
gem 'activerecord-import', '~>0.2.11' #massive insert tool

# Tools
gem 'rack-mini-profiler', '~>0', :group => [:development, :production]
gem 'foreman', '~>0.60.2'
gem 'faker', '~> 1.0', :group => [:development, :test]

#third parties
gem 'google_drive', '~> 0.3.2'
gem 'fog', '~> 1.7.0'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '~> 1.3.0'
end

group :development do
  gem 'annotate', '~> 2.5.0.pre'
  gem 'letter_opener', '~> 1.0'
  #tools
  gem 'bullet', '~>4.2'
  gem 'rails_best_practices', '~> 1'
  #tooling
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'rspec-rails', '~> 2.10'
  gem 'capybara', '~> 1.1.2'
  gem 'guard-rspec', '~> 1.2.1'
  gem 'guard', '~> 1.5.4'
  gem 'factory_girl_rails', '~> 4.1.0'
  gem 'capybara-webkit', '~> 0.12.1'
  gem 'database_cleaner', '~>0.9.1'

  # Tools
  gem 'simplecov', '~> 0.7', :require => false
  gem 'guard-brakeman', '~> 0'

    #Linux gems
    gem 'rb-inotify', '~> 0.8.8'
    gem 'libnotify', '~> 0.8.0'
    gem 'guard-spork', '~> 1.2.3'
    gem 'spork', '~> 0.9.2'
end