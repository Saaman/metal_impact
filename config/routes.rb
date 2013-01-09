MetalImpact::Application.routes.draw do
  filter :locale

  resources :albums
  resources :artists, :except => [:destroy, :update, :edit] do
    get 'search', :on => :collection
    get 'smallblock', :on => :member
  end
  resources :music_labels, :only => [:new, :create] do
    get 'smallblock', :on => :member
  end

  namespace :administration do
    resources :users, :only => [:index, :destroy, :update]
    resources :imports, :only => [:index, :show, :update] do
      put 'prepare', :on => :member
      put 'import', :on => :member
      resources :failures, :only => :index, :controller => 'import_failures' do
        delete 'clear', :on => :collection
      end
    end
    resources :import_entries, :only => [:edit, :update]
  end

  devise_for :users,:controllers => { :registrations => "users/registrations", :passwords => "users/passwords" }, :skip => [:sessions]
  devise_scope :user do
    #FIX : this is a temporay fix to allow sign-out link inside Bootstrap dropdown to work.
    #FIX : Check here for original issue : https://github.com/twitter/bootstrap/issues/4688
    #FIX : Boostrap issue is going to be fixed officially soon. Once it's corrected, put value :delete again
    delete "logout" => "devise/sessions#destroy", :as => :destroy_user_session
    get "logout" => "devise/sessions#destroy", :as => :destroy_user_session
    get "login" => "devise/sessions#new", :as => :new_user_session
    post "login" => "devise/sessions#create", :as => :user_session
    get "signup" => "users/registrations#new"
    post "signup" => "users/registrations#create"
    get 'users/password/email-sent' => 'users/passwords#email_sent', :as => :email_sent_user_password
    constraints :format => :json do
      get 'users/is-pseudo-taken' => 'users/registrations#is_pseudo_taken', :as => :is_pseudo_taken_user_registration
    end
  end

  get 'show_image' => 'home#show_image', :defaults => { :format => 'js' }, :as => :show_image
  match 'dashboard' => 'administration/monitoring#dashboard', :via => [:get, :post]

  root to: 'home#index'


end
#== Route Map
# Generated on 09 Jan 2013 15:03
#
#                                      POST     /albums(.:format)                                           albums#create
#                            new_album GET      /albums/new(.:format)                                       albums#new
#                           edit_album GET      /albums/:id/edit(.:format)                                  albums#edit
#                                album GET      /albums/:id(.:format)                                       albums#show
#                                      PUT      /albums/:id(.:format)                                       albums#update
#                                      DELETE   /albums/:id(.:format)                                       albums#destroy
#                       search_artists GET      /artists/search(.:format)                                   artists#search
#                    smallblock_artist GET      /artists/:id/smallblock(.:format)                           artists#smallblock
#                              artists GET      /artists(.:format)                                          artists#index
#                                      POST     /artists(.:format)                                          artists#create
#                           new_artist GET      /artists/new(.:format)                                      artists#new
#                               artist GET      /artists/:id(.:format)                                      artists#show
#               smallblock_music_label GET      /music_labels/:id/smallblock(.:format)                      music_labels#smallblock
#                         music_labels POST     /music_labels(.:format)                                     music_labels#create
#                      new_music_label GET      /music_labels/new(.:format)                                 music_labels#new
#                 administration_users GET      /administration/users(.:format)                             administration/users#index
#                  administration_user PUT      /administration/users/:id(.:format)                         administration/users#update
#                                      DELETE   /administration/users/:id(.:format)                         administration/users#destroy
#        prepare_administration_import PUT      /administration/imports/:id/prepare(.:format)               administration/imports#prepare
#         import_administration_import PUT      /administration/imports/:id/import(.:format)                administration/imports#import
# clear_administration_import_failures DELETE   /administration/imports/:import_id/failures/clear(.:format) administration/import_failures#clear
#       administration_import_failures GET      /administration/imports/:import_id/failures(.:format)       administration/import_failures#index
#               administration_imports GET      /administration/imports(.:format)                           administration/imports#index
#                administration_import GET      /administration/imports/:id(.:format)                       administration/imports#show
#                                      PUT      /administration/imports/:id(.:format)                       administration/imports#update
#     edit_administration_import_entry GET      /administration/import_entries/:id/edit(.:format)           administration/import_entries#edit
#          administration_import_entry PUT      /administration/import_entries/:id(.:format)                administration/import_entries#update
#                        user_password POST     /users/password(.:format)                                   users/passwords#create
#                    new_user_password GET      /users/password/new(.:format)                               users/passwords#new
#                   edit_user_password GET      /users/password/edit(.:format)                              users/passwords#edit
#                                      PUT      /users/password(.:format)                                   users/passwords#update
#             cancel_user_registration GET      /users/cancel(.:format)                                     users/registrations#cancel
#                    user_registration POST     /users(.:format)                                            users/registrations#create
#                new_user_registration GET      /users/sign_up(.:format)                                    users/registrations#new
#               edit_user_registration GET      /users/edit(.:format)                                       users/registrations#edit
#                                      PUT      /users(.:format)                                            users/registrations#update
#                                      DELETE   /users(.:format)                                            users/registrations#destroy
#                    user_confirmation POST     /users/confirmation(.:format)                               devise/confirmations#create
#                new_user_confirmation GET      /users/confirmation/new(.:format)                           devise/confirmations#new
#                                      GET      /users/confirmation(.:format)                               devise/confirmations#show
#                          user_unlock POST     /users/unlock(.:format)                                     devise/unlocks#create
#                      new_user_unlock GET      /users/unlock/new(.:format)                                 devise/unlocks#new
#                                      GET      /users/unlock(.:format)                                     devise/unlocks#show
#                 destroy_user_session DELETE   /logout(.:format)                                           devise/sessions#destroy
#                 destroy_user_session GET      /logout(.:format)                                           devise/sessions#destroy
#                     new_user_session GET      /login(.:format)                                            devise/sessions#new
#                         user_session POST     /login(.:format)                                            devise/sessions#create
#                               signup GET      /signup(.:format)                                           users/registrations#new
#                                      POST     /signup(.:format)                                           users/registrations#create
#             email_sent_user_password GET      /users/password/email-sent(.:format)                        users/passwords#email_sent
#    is_pseudo_taken_user_registration GET      /users/is-pseudo-taken(.:format)                            users/registrations#is_pseudo_taken {:format=>:json}
#                           show_image GET      /show_image(.:format)                                       home#show_image {:format=>"js"}
#                            dashboard GET|POST /dashboard(.:format)                                        administration/monitoring#dashboard
#                                 root          /                                                           home#index
