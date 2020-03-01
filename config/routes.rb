Rails.application.routes.draw do
  get 'listing', :to => 'currencies#index'
  get 'history/:currency', :to => 'currencies#history', as: 'history', constraints: lambda { |request| History.currencies.keys.include?(request.params[:currency]) }

  post 'capture', :to => 'currencies#capture'
  root to: "currencies#index"
end
