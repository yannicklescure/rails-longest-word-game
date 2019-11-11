Rails.application.routes.draw do
  get '/new', to: 'games#new'
  get '/score', to: 'games#score'
  post '/score', to: 'games#score'
end
