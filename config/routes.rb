BiClient::Application.routes.draw do
  resources :flowsheets do
    collection do
      get 'vac_row'
      post 'update_vac_row'
    end
  end
  resources :observations
  resources :alerts
  resources :value_set_members
  resources :value_sets
  resources :responses
  resources :questions
  resources :alert_guideline_steps
  resources :patient_guideline_steps
  resources :patient_guidelines
  resources :guideline_steps
  resources :guidelines
  resources :locations do
    get 'updated'
  end
  resources :user_sessions
  resources :users
  resources :patients do
    get 'flowsheet'
  end
  resources :body_systems
  resources :locations
  resources :test_message
  resources :observations
  get "home/index"

  match "login", :controller => "user_sessions", :action => "new"
  match "logout", :controller => "user_sessions", :action => "destroy"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):  # Sample resource route with options:
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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
