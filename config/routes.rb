Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { registrations: 'auth/registrations', confirmations: 'auth/confirmations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :girl
  resources :user do
    collection do
      get 'get_gold'
    end
  end
  resources :user_girl
  resources :project
  resources :task do
    member do
      put :update_status
    end
    collection do
      get :custom
      get :count_not_finish_tasks
    end
  end
  resources :serifu
  post '/callback' => 'linebot#callback'
  get '/push_remind' => 'linebot#push_message'
end
