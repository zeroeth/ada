Ada::Application.routes.draw do
  get "welcome/index"
  get "profile" => 'welcome#profile'

  devise_for :users
  match "users/authenticate_for_token" => "users#authenticate_for_token", :via => :post
  match "data_collector" => "data#create", :via => :post
  match "data/heatmap" => "data#heatmap"
  match "user/user_data" => "users#get_data" 

  resources :data do
    collection do 
      post :tenacity_player_stats
      get :find_tenacity_player
    end
  end

  resources :users, :only => [:index] do
    collection do
      get :new_sequence
      post :create_sequence

      get :reset_password_form
      put :reset_password
    end
  end

  # OAuth provider:
  get '/auth/ada/authorize' => 'oauth#authorize'
  get '/auth/ada/access_token' => 'oauth#access_token'
  get '/auth/ada/user' => 'oauth#user'
  post '/oauth/token' => 'oauth#access_token'

  root :to => 'welcome#index'
end
