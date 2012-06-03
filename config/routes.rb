MetalImpact::Application.routes.draw do
  resources :albums
  resources :music_labels, :only => [:new, :create]

  namespace :administration do
    resources :users, :only => [:index, :destroy, :update]
  end

  devise_for :users,  :controllers => { :registrations => "users/registrations", :sessions => "users/sessions" }, :skip => [:sessions]
  devise_scope :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get 'users/is-pseudo-taken' => 'users/registrations#is_pseudo_taken', :as => :is_pseudo_taken_user_registration
  end
  
  root to: 'home#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
#== Route Map
# Generated on 21 May 2012 18:00
#
#                                   POST   /albums(.:format)                   albums#create
#                         new_album GET    /albums/new(.:format)               albums#new
#                        edit_album GET    /albums/:id/edit(.:format)          albums#edit
#                             album GET    /albums/:id(.:format)               albums#show
#                                   PUT    /albums/:id(.:format)               albums#update
#                                   DELETE /albums/:id(.:format)               albums#destroy
#                      music_labels POST   /music_labels(.:format)             music_labels#create
#                   new_music_label GET    /music_labels/new(.:format)         music_labels#new
#              administration_users GET    /administration/users(.:format)     administration/users#index
#               administration_user PUT    /administration/users/:id(.:format) administration/users#update
#                                   DELETE /administration/users/:id(.:format) administration/users#destroy
#                     user_password POST   /users/password(.:format)           devise/passwords#create
#                 new_user_password GET    /users/password/new(.:format)       devise/passwords#new
#                edit_user_password GET    /users/password/edit(.:format)      devise/passwords#edit
#                                   PUT    /users/password(.:format)           devise/passwords#update
#          cancel_user_registration GET    /users/cancel(.:format)             users/registrations#cancel
#                 user_registration POST   /users(.:format)                    users/registrations#create
#             new_user_registration GET    /users/sign_up(.:format)            users/registrations#new
#            edit_user_registration GET    /users/edit(.:format)               users/registrations#edit
#                                   PUT    /users(.:format)                    users/registrations#update
#                                   DELETE /users(.:format)                    users/registrations#destroy
#                 user_confirmation POST   /users/confirmation(.:format)       devise/confirmations#create
#             new_user_confirmation GET    /users/confirmation/new(.:format)   devise/confirmations#new
#                                   GET    /users/confirmation(.:format)       devise/confirmations#show
#                       user_unlock POST   /users/unlock(.:format)             devise/unlocks#create
#                   new_user_unlock GET    /users/unlock/new(.:format)         devise/unlocks#new
#                                   GET    /users/unlock(.:format)             devise/unlocks#show
#                  new_user_session GET    /signin(.:format)                   devise/sessions#new
#                      user_session POST   /signin(.:format)                   devise/sessions#create
#              destroy_user_session DELETE /signout(.:format)                  devise/sessions#destroy
# is_pseudo_taken_user_registration GET    /users/is-pseudo-taken(.:format)    users/registrations#is_pseudo_taken
#                              root        /                                   home#index
