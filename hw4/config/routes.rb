Rottenpotatoes::Application.routes.draw do
 
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  get '/similar', to: 'movies#similar' ,as: 'search_directors'
  
end
