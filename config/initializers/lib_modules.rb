#http://hemju.com/index.php/2011/02/rails-3-quicktip-auto-reload-lib-folders-in-development-mode/

#Store the lib/modules pathes to be able to reload them on dev environment
RELOAD_LIBS = Dir[Rails.root + 'lib/modules/**/*.rb'] if Rails.env.development?