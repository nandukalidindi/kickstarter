Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'login#login'

  get 'home' => 'application#home'

  get 'login' => 'login#login'

  post 'login' => 'login#authenticate'

  get 'signup' => 'login#signup'

  post 'signup' => 'login#create_user'

  get 'projects' => 'project#index'

  get 'projects/new' => 'project#new'

  post 'projects' => 'project#create'

  get 'projects/:id' => 'project#show'

  post 'projects/:id/pledge' => 'project#pledge'

  post 'projects/:id/rating' => 'project#rating'

  post 'projects/:id/comment' => 'project#comment', :as => 'project_comments'

  post 'projects/:id/like' => 'project#like'

  get 'users/:id' => 'user#show'

  get 'users/:id/followers' => 'user#followers'

  get 'users/:id/following' => 'user#following'

  post 'users/:id/profile/:profile_type/follow' => 'user#follow'

  post 'users/:id/profile/:profile_type/unfollow' => 'user#unfollow'

  post 'users/:id/following/follow' => 'user#follow'

  get 'users/:id/account' => 'user#account'

  get 'users/:id/profile' => 'user#profile'

  get 'users/:id/credit_cards' => 'user#credit_cards'

  get 'users/:id/profile/about' => 'user#about'

  get 'users/:id/profile/backed' => 'user#backed'

  get 'users/:id/profile/comments' => 'user#comments'

  post 'credit_cards' => 'credit_card#new'

  delete 'credit_cards/:cc_number' => 'credit_card#destroy'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
