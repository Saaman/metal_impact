def voting_routes
  member do
    put 'upvote'
    put 'downvote'
  end
end

MetalImpact::Application.routes.draw do
  filter :locale

  resources :albums do
    voting_routes
  end

  resources :artists, :except => [:destroy, :update, :edit] do
    get 'search', :on => :collection
    get 'smallblock', :on => :member
    voting_routes
  end

  resources :music_labels, :only => [:new, :create] do
    get 'search', :on => :collection
    get 'smallblock', :on => :member
  end

  namespace :administration do
    resources :users, :only => [:index, :destroy, :update]
    resources :imports, :only => [:index, :show, :update] do
      put 'prepare', :on => :member
      put 'import', :on => :member
      get 'failures', :on => :member
      delete 'clear_failures', :on => :member
    end
    resources :import_entries, :only => [:edit, :update]
    resources :contributions, :only => [:index, :show] do
      put 'approve', :on => :member
      put 'refuse', :on => :member
    end
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
  match 'dashboard' => 'administration/dashboard#index', :via => [:get]
  match 'toggle_debug' => 'administration/dashboard#toggle_debug', :via => [:post]

  mount DjMon::Engine => 'dj_mon'

  root to: 'home#index'

end

#== Route Map
# Generated on 06 Mar 2013 12:22
#
#                       downvote_album PUT    /albums/:id/downvote(.:format)                       albums#downvote
#                               albums GET    /albums(.:format)                                    albums#index
#                                      POST   /albums(.:format)                                    albums#create
#                            new_album GET    /albums/new(.:format)                                albums#new
#                           edit_album GET    /albums/:id/edit(.:format)                           albums#edit
#                                album GET    /albums/:id(.:format)                                albums#show
#                                      PUT    /albums/:id(.:format)                                albums#update
#                                      DELETE /albums/:id(.:format)                                albums#destroy
#                       search_artists GET    /artists/search(.:format)                            artists#search
#                    smallblock_artist GET    /artists/:id/smallblock(.:format)                    artists#smallblock
#                        upvote_artist PUT    /artists/:id/upvote(.:format)                        artists#upvote
#                      downvote_artist PUT    /artists/:id/downvote(.:format)                      artists#downvote
#                              artists GET    /artists(.:format)                                   artists#index
#                                      POST   /artists(.:format)                                   artists#create
#                           new_artist GET    /artists/new(.:format)                               artists#new
#                               artist GET    /artists/:id(.:format)                               artists#show
#                  search_music_labels GET    /music_labels/search(.:format)                       music_labels#search
#               smallblock_music_label GET    /music_labels/:id/smallblock(.:format)               music_labels#smallblock
#                         music_labels POST   /music_labels(.:format)                              music_labels#create
#                      new_music_label GET    /music_labels/new(.:format)                          music_labels#new
#                 administration_users GET    /administration/users(.:format)                      administration/users#index
#                  administration_user PUT    /administration/users/:id(.:format)                  administration/users#update
#                                      DELETE /administration/users/:id(.:format)                  administration/users#destroy
#        prepare_administration_import PUT    /administration/imports/:id/prepare(.:format)        administration/imports#prepare
#         import_administration_import PUT    /administration/imports/:id/import(.:format)         administration/imports#import
#       failures_administration_import GET    /administration/imports/:id/failures(.:format)       administration/imports#failures
# clear_failures_administration_import DELETE /administration/imports/:id/clear_failures(.:format) administration/imports#clear_failures
#               administration_imports GET    /administration/imports(.:format)                    administration/imports#index
#                administration_import GET    /administration/imports/:id(.:format)                administration/imports#show
#                                      PUT    /administration/imports/:id(.:format)                administration/imports#update
#     edit_administration_import_entry GET    /administration/import_entries/:id/edit(.:format)    administration/import_entries#edit
#          administration_import_entry PUT    /administration/import_entries/:id(.:format)         administration/import_entries#update
#  approve_administration_contribution PUT    /administration/contributions/:id/approve(.:format)  administration/contributions#approve
#   refuse_administration_contribution PUT    /administration/contributions/:id/refuse(.:format)   administration/contributions#refuse
#         administration_contributions GET    /administration/contributions(.:format)              administration/contributions#index
#          administration_contribution GET    /administration/contributions/:id(.:format)          administration/contributions#show
#                        user_password POST   /users/password(.:format)                            users/passwords#create
#                    new_user_password GET    /users/password/new(.:format)                        users/passwords#new
#                   edit_user_password GET    /users/password/edit(.:format)                       users/passwords#edit
#                                      PUT    /users/password(.:format)                            users/passwords#update
#             cancel_user_registration GET    /users/cancel(.:format)                              users/registrations#cancel
#                    user_registration POST   /users(.:format)                                     users/registrations#create
#                new_user_registration GET    /users/sign_up(.:format)                             users/registrations#new
#               edit_user_registration GET    /users/edit(.:format)                                users/registrations#edit
#                                      PUT    /users(.:format)                                     users/registrations#update
#                                      DELETE /users(.:format)                                     users/registrations#destroy
#                    user_confirmation POST   /users/confirmation(.:format)                        devise/confirmations#create
#                new_user_confirmation GET    /users/confirmation/new(.:format)                    devise/confirmations#new
#                                      GET    /users/confirmation(.:format)                        devise/confirmations#show
#                          user_unlock POST   /users/unlock(.:format)                              devise/unlocks#create
#                      new_user_unlock GET    /users/unlock/new(.:format)                          devise/unlocks#new
#                                      GET    /users/unlock(.:format)                              devise/unlocks#show
#                 destroy_user_session DELETE /logout(.:format)                                    devise/sessions#destroy
#                 destroy_user_session GET    /logout(.:format)                                    devise/sessions#destroy
#                     new_user_session GET    /login(.:format)                                     devise/sessions#new
#                         user_session POST   /login(.:format)                                     devise/sessions#create
#                               signup GET    /signup(.:format)                                    users/registrations#new
#                                      POST   /signup(.:format)                                    users/registrations#create
#             email_sent_user_password GET    /users/password/email-sent(.:format)                 users/passwords#email_sent
#    is_pseudo_taken_user_registration GET    /users/is-pseudo-taken(.:format)                     users/registrations#is_pseudo_taken {:format=>:json}
#                           show_image GET    /show_image(.:format)                                home#show_image {:format=>"js"}
#                            dashboard GET    /dashboard(.:format)                                 administration/dashboard#index
#                         toggle_debug POST   /toggle_debug(.:format)                              administration/dashboard#toggle_debug
#                               dj_mon        /dj_mon                                              DjMon::Engine
#                                 root        /                                                    home#index
# 
# Routes for DjMon::Engine:
#       all_dj_reports GET    /dj_reports/all(.:format)       dj_mon/dj_reports#all
#    failed_dj_reports GET    /dj_reports/failed(.:format)    dj_mon/dj_reports#failed
#    active_dj_reports GET    /dj_reports/active(.:format)    dj_mon/dj_reports#active
#    queued_dj_reports GET    /dj_reports/queued(.:format)    dj_mon/dj_reports#queued
# dj_counts_dj_reports GET    /dj_reports/dj_counts(.:format) dj_mon/dj_reports#dj_counts
#  settings_dj_reports GET    /dj_reports/settings(.:format)  dj_mon/dj_reports#settings
#      retry_dj_report POST   /dj_reports/:id/retry(.:format) dj_mon/dj_reports#retry
#           dj_reports GET    /dj_reports(.:format)           dj_mon/dj_reports#index
#                      POST   /dj_reports(.:format)           dj_mon/dj_reports#create
#        new_dj_report GET    /dj_reports/new(.:format)       dj_mon/dj_reports#new
#       edit_dj_report GET    /dj_reports/:id/edit(.:format)  dj_mon/dj_reports#edit
#            dj_report GET    /dj_reports/:id(.:format)       dj_mon/dj_reports#show
#                      PUT    /dj_reports/:id(.:format)       dj_mon/dj_reports#update
#                      DELETE /dj_reports/:id(.:format)       dj_mon/dj_reports#destroy
#                 root        /                               dj_mon/dj_reports#index
