Rails.application.routes.draw do

# 管理者用
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
    root to: "homes#top"
    resources :inquiries, only: [:show, :update]
    resources :users,     only: [:index, :show, :update]
  end

#--------------------------------------------------------------------------------

# 利用者用
devise_for :users, skip: [:registrations, :passwords], controllers: {
  sessions: "public/sessions"
}

devise_scope :user do
  get  "users/sign_up/:user_type", to: "public/registrations#new",    as: :new_user_registration
  post "users",                    to: "public/registrations#create", as: :user
end

  scope module: :public do

    root to: "homes#top"
    get      "/about"        => "homes#about",  as: "about"
    get      "/users/branch" => "homes#branch", as: "branch" # deviseのフォーム画面2種は条件分岐

    get       "/artist/arts/:id"    => "arts#artist_arts", as: "artist_arts"
    get       "/my_album"    => "arts#my_album"
    resources :arts,            only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resources :likes,           only: [:cteate, :destroy]
      resources :engagements,     only: [:show, :create, :destroy]
    end

    resources :users, only: [] do
      resources :follows,         only: [:create, :destroy]
    end
    get       "/artists"          => "users#index"
    get       "/users/artist/:id" => "users#artist", as: "artist"
    get       "/users/fan/:id"    => "users#fan",    as: "fan"
    get       "/users/edit"       => "users#edit"
    patch     "/users/edit"       => "users#update"
    get       "/users/confirm"    => "users#confirm"
    patch     "/users/withdraw"   => "users#withdraw"

    resources :follows_notices, only: [:index]

    resources :helps,           only: [:index, :create]
    get       "/helps/inquiry" => "helps#new"
    get       "/helps/confirm" => "helps#confirm"
    post      "/helps/confirm" => "helps#confirm"

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
