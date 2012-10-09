# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#this line is to make carrierwave work on Heroku
use Rack::Static, :urls => ['/carrierwave'], :root => 'tmp'
run MetalImpact::Application
