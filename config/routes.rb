Rails.application.routes.draw do
  root "posts#index"
  patch '/posts/:id/autosave', to: 'posts#autosave', as: 'autosave_post'
  resources :posts
end
