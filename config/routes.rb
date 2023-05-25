Rails.application.routes.draw do

# 管理者用 /admin 5ページ
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
    root to: "homes#top"
    resources :inquiries, only: [:show, :update]
    resources :users,     only: [:index, :show, :update]
  end

#--------------------------------------------------------------------------------

# 利用者用 /users 20ページ
devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: "public/sessions"
}

  scope module: :public do

    root to: "homes#top"
    get      "/about"                   => "homes#about",  as: "about"
    get      "/users/select/:user_type" => "homes#select", as: "select" # deviseのフォーム画面2種は条件分岐

    resources :arts,            only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resources :likes,           only: [:cteate, :destroy]
      resources :engagements,     only: [:show, :create, :destroy]
    end
    get       "/my_album"       => "arts#my_album"

    resources :users,           only: [:update]
    get       "/my_page"        => "users#show"
    get       "/my_page/edit"   => "users#edit"
    get       "/users/confirm"  => "users#confirm"
    patch     "/users/withdraw" => "users#withdraw"

    resources :artists,         only: [:index, :show] do
      resources :follows,         only: [:create, :destroy]
    end

    resources :follows_notices, only: [:index]

    resources :helps,           only: [:index, :create]
    get       "/helps/inquiry"  => "helps#new"
    get       "/helps/confirm"  => "helps#confirm"

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
