Rails.application.routes.draw do

# 管理者用
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
    root to: "homes#top"
    resources :inquiries, only: [:show, :update]
    get       "/users/search"  => "users#search"
    resources :users,     only: [:index, :show, :update]
  end

#--------------------------------------------------------------------------------

# 利用者用
devise_for :users, skip: [:registrations, :passwords], controllers: {
  sessions: "public/sessions"
}

devise_scope :user do
  get  "users/sign_up/:user_type", to: "public/registrations#new",    as: :new_user_registration
  post "users/sign_up/:user_type", to: "public/registrations#create", as: :user
end

  scope module: :public do

    root to: "homes#top"
    get      "/about"        => "homes#about",  as: "about"
    get      "/users/branch" => "homes#branch", as: "branch" # deviseのフォーム画面2種は条件分岐

    get       "/arts/hashtag/:tag"  => "arts#hashtag",     as: "arts_hashtag"
    get       "/arts/view/:id"      => "arts#view",        as: "art_view"
    get       "/arts/search"        => "arts#search"
    get       "/artist/arts/:id"    => "arts#arts_artist", as: "artist_arts"
    get       "/arts/my_album"      => "arts#my_album",    as: "my_album"
    resources :arts,            only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resource  :likes,           only: [:create, :destroy] # resource 単数形にすると/:idがURLに含まれなくなる 1ユーザ、1投稿に対して、いいね1回のみのため
      patch     "/engagements/:id"  => "engagements#remove", as: "engagement"
      resource  :engagements,     only: [:show, :create]
    end

    resources :users, only: [] do
      resources :follows,         only: [:create, :destroy]
    end
    get       "/artists"              => "users#index"
    get       "/users/artist/:id"     => "users#artist", as: "artist"
    get       "/users/artsit/search"  => "users#search"
    get       "/users/fan/:id"        => "users#fan",    as: "fan"
    get       "/users/edit"           => "users#edit"
    patch     "/users/edit"           => "users#update"
    get       "/users/confirm"        => "users#confirm"
    patch     "/users/withdraw"       => "users#withdraw"

    patch     "/follows_notices/update_all" => "follows_notices#update_all"
    resources :follows_notices, only: [:index, :update]

    resources :helps,           only: [:index, :create]
    get       "/helps/inquiry" => "helps#new"
    get       "/helps/confirm" => "helps#confirm"
    post      "/helps/confirm" => "helps#confirm"

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
