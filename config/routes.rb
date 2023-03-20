Rails.application.routes.draw do
  root "posts#index"
  patch '/posts/:id/autosave', to: 'posts#autosave', to: 'autosave_post'
  resources :posts
end
