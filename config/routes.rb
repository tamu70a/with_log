Rails.application.routes.draw do
  get "static_pages/top"
  get "habits/index"
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }, skip: [ :passwords ]

  get "homes/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"
  resource :home_memo, only: [ :update ]
  resources :tasks, only: [ :create, :update, :destroy ]
  resources :habits, only: [ :new, :index, :edit, :create, :update, :destroy ] do
    patch :toggle_check, on: :member
  end
  resources :memos
  resources :body_records, only: [ :index, :create ]
  resources :children, only: [] do
    resources :growth_records, only: [ :index, :create, :update ]
  end
  namespace :settings do
    root "dashboards#show"
    resources :body_records, only: [ :index, :show, :edit, :update, :destroy ]
    resources :weight_goals, only: [ :index, :create  ]
    resource :growth_setting, only: [ :show, :update ] do
      resource :display, only: [ :show, :update ], module: :growth_settings
    end
    resources :children
    resource :theme_setting
    resource :account_setting
    resource :buddy_setting, only: [ :show, :edit, :update ]
  end
  get "terms", to: "static#terms"
  get "privacy", to: "static#privacy"
end
