Poolofgreatness::Application.routes.draw do
  get "games/index"

  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login

  match 'pools/join' => 'pools#join', :as => :joinpool
  match 'pools/find' => 'pools#find', :as => :findpools
  match 'pools/search' => 'pools#search', :as => :poolsearch

  match 'games/find' => "games#find", :as => :find_games

  resources :pickem_pools do
    member do
      get 'configure'
      get 'show_results'
      post 'update'
      get 'home'
      get 'viewstats'
      get 'view_allgames'
      get 'view_games'
      get 'administer'
      get 'admin_pick_weekly_games'
      post 'create_games'
      post 'save_picks'
      get 'modify_accounting'
      get 'view_transactions'
      put 'update_transactions'
    end
  end

  resources :sessions
  resources :sites do
    member do
      get 'join'
      get 'newpool'
      post 'add_pool'
      get 'administer'
      get 'newtransaction'
      post 'create_transaction'
    end

    collection do
      get 'find'
      get 'search'
    end

  end

  resources :pools
  resources :users
  resources :games do
    collection do
      get'find'
      put 'update_individual'
      get 'parse_college_scores'
      get 'parse_pro_scores'
      get 'score_pickem'
    end
  end

  resources :ncaagames, :controller => "games", :type => 'Ncaagame'
  resources :nflgames, :controller => "games", :type => "Nflgame"

  resources :survivor_pools do
    member do
      get "viewpicksheet"
      post "makepick"
      get "standings"
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
