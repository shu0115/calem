Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :schedules do
    get 'pager',          on: :collection
    get 'set_off_day',    on: :collection
    get 'cancel_off_day', on: :collection
  end

  post 'top/send_access_token',          to: 'top#send_access_token',   as: :send_access_token
  get  'top/verify_access_token/:token', to: 'top#verify_access_token', as: :verify_access_token

  # For OmniAuth
  get "/auth/:provider/callback" => "sessions#callback"
  get "/auth/failure"            => "sessions#failure"
  get "/logout"                  => "sessions#destroy", as: :logout

  root to: 'top#index'
end
