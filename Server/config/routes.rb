Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: 'registrations', sessions: 'sessions'}

  resources :answers, defaults: {format: :json}

  resources :questions, defaults: {format: :json}

  resources :comments, defaults: {format: :json} do
    get 'user',    on: :member
    get 'chapter', on: :member
  end

  resources :homeworks, defaults: {format: :json} do
    get 'user', on: :member
    get 'book', on: :member
  end

  resources :chapters, defaults: {format: :json} do
    get 'unit',      on: :member
    get 'comments',  on: :member
    get 'questions', on: :member
  end

  resources :units, defaults: {format: :json} do
    get 'teacher',   on: :member
    get 'book',      on: :member
    get 'users',     on: :member
    get 'chapters',  on: :member
    get 'questions', on: :member
  end

  resources :books, defaults: {format: :json} do
    get 'assembly', on: :member
    get 'users',    on: :member
    get 'units',    on: :member
  end

  resources :users, defaults: {format: :json} do
    get 'assemblies',   on: :member
    get 'homeworks',    on: :member
    get 'comments',     on: :member
    put 'add_assembly', on: :member
    post 'answer_exam', on: :member
    put 'answer_quiz',  on: :member
  end

  resources :assemblies, defaults: {format: :json} do
    get 'teachers',    on: :member
    get 'teacher_ids', on: :member
    get 'users',       on: :member
    get 'books',       on: :member
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  #   namespace :teacher do
  #     # Directs /teacher/products/* to Teacher::ProductsController
  #     # (app/controllers/teacher/products_controller.rb)
  #     resources :products
  #   end
end
