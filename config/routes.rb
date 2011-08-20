Poolofgreatness::Application.routes.draw do
  get "games/index"

  get "pickem_pools/configure"

  post "pickem_pools/update"

  get "pickem_pools/home"

  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login
  match 'pickem_configure' => 'pickem_pools#configure', :as => :pickem_configure
  match 'pickem_pools/home' => 'pickem_pools#home', :as => :pickem_home
  match 'pickem_weeklygames' => 'pickem_pools#view_games', :as => :pickem_weeklygames
  match 'pickem_administer' => 'pickem_pools#administer', :as => :pickem_administer
  match 'pickem_view_allgames' => 'pickem_pools#view_allgames', :as => :pickem_view_allgames

  match 'pools/join' => 'pools#join', :as => :joinpool
  match 'pools/find' => 'pools#find', :as => :findpools
  match 'pools/search' => 'pools#search', :as => :poolsearch
  match 'pickem_pools/create_games' => 'pickem_pools#create_games', :as => :create_games
  match 'pickem_pools/save_picks' => "pickem_pools#save_picks", :as => :save_picks 
  match 'pickem_pools/admin_pick_weekly_games' => "pickem_pools#admin_pick_weekly_games", :as => :admingames
  match 'games/find' => "games#find", :as => :find_games
  resources :sessions
  resources :pools
  resources :users
  resources :games do
    collection do
      get'find'
      put 'update_individual'
    end
  end

  match '/pricing', :to => 'pages#pricing'
  match '/features', :to => 'pages#features'

  root :to => 'pages#home'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
