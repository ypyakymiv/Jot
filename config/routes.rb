Rails.application.routes.draw do

  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth'
    api_version(:module => "V1", :path => {:value => "v1"}, :default => true) do
      resources :threads, only: [:show]
      resources :comments, except: [:edit, :new, :index]
      resources :users, except: [:edit, :new] do
        get :attending
        get :friends
        post :friend, to: 'friends#create'
        delete :friend, to: 'friends#destroy'
        post :request, to: 'requests#create'
        delete :request, to: 'requests#destroy'
        post :block, to: 'blocks#create'
        delete :block, to: 'blocks#destroy'
      end

      get :friends, to: 'friends#index'
      get :requests, to: 'requests#requests'
      get :pending, to: 'requests#pending'
      get :blocks, to: 'blocks#index'
      resources :events, except: [:edit, :new] do
        post :sign_up
        post :unsign_up
        get :attending
      end
    end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end
