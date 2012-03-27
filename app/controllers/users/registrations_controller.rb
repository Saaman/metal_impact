class Users::RegistrationsController < Devise::RegistrationsController
  load_and_authorize_resource
end