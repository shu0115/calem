Calem::Application.routes.draw do
  resources :schedules do
    get 'pager', on: :collection
  end

  # For OmniAuth
  get "/auth/:provider/callback" => "sessions#callback"
  get "/auth/failure"            => "sessions#failure"
  get "/logout"                  => "sessions#destroy", as: :logout

  root to: 'top#index'
end
