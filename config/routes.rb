Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}
  resources :loans do
    member do
      post 'payments', to: 'loans#create_payment'
      get 'payments', to: 'loans#payments_index'
    end
    resources :payments, only: [:show], controller: 'loans'
  end

end