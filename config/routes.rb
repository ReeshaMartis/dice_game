Rails.application.routes.draw do
  resources :games, only: [:show,:create,:index] do
    post 'play', on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
