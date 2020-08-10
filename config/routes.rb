Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "home#user_top"
  get "hairdresser_top" => "home#hairdresser_top", as: "hairdresser_top"

  #users::reservationsコントローラ users::hairdressersコントローラ  namespaceを使う時は使っていないものより上に書く 思い通りのrutingにならないerrorがでた
  namespace :users do
    get "set_week_calendar_reservation" => "reservations#set_week_calendar_reservation", as: "set_week_calendar_reservation"
    get "set_month_calendar_reservation" => "reservations#set_month_calendar_reservation", as: "set_month_calendar_reservation"
    resources :reservations, only: [:edit, :index]
    patch "various_update" => "reservations#various_update", as: "various_update"
    post "pay" => "reservations#pay", as: "card_resevation_pay"
    post "cancel" => "reservations#cancel", as: "reservation_cancel"
    get "complete" => "reservations#complete", as: "complete"
    
    resources :hairdressers, only: [:show, :index]
  end
  
  #usersコントローラ
  resources :users, only: [:show, :create]
  post "user/login" => "users#login", as: "user_login"
  post "user/logout" => "users#logout", as: "user_logout"

  #hairdressers::reservationsコントローラ namespaceを使う時は使っていないものより上に書く 思い通りのrutingにならないerrorがでた
  namespace :hairdressers do
    get "set_week_calendar_reservation" => "reservations#set_week_calendar_reservation", as: "set_week_calendar_reservation"
    post "create_destroy_reservation" => "reservations#create_destroy_reservation", as: "create_destroy_reservation"
    get "set_month_calendar_reservation" => "reservations#set_month_calendar_reservation", as: "set_month_calendar_reservation"
    resources :reservations, only: [:new, :index, :create, :destroy]
    get "cancel_index" => "reservations#cancel_index", as: "cancel_index"
  end

  #hairdressersコントローラ
  resources :hairdressers
  post "hairdresser/login" => "hairdressers#login", as: "hairdresser_login"
  post "hairdresser/logout" => "hairdressers#logout", as: "hairdresser_logout"
  get "hairdresser/wait/:id" => "hairdressers#wait", as: "hairdresser_wait"

  #adminsコントローラー
  get "admins/user_index" => "admins#user_index", as: "admins_user_index"
  get "admins/hairdresser_index" => "admins#hairdresser_index", as: "admins_hairdresser_index"
  get "admins/user_chart" => "admins#user_chart", as: "admins_user_chart"
  get "admins/hairdresser_chart" => "admins#hairdresser_chart", as: "admins_hairdresser_chart"
  get "admins/sell_chart" => "admins#sell_chart", as: "admins_sell_chart"
  get "admins/login_form" => "admins#login_form", as: "admins_login_form"
  post "admins/login" => "admins#login", as: "admins_login"
  get "admins/hairdresser_judge_index" => "admins#hairdresser_judge_index", as: "admins_hairdresser_judge_index"
  patch "admins/permit/:id" => "admins#permit", as: "admins_permit"
  get "admins/reject/:id" => "admins#reject_form", as: "admins_reject_form"
  patch "admins/reject/:id" => "admins#reject", as: "admins_reject"
  post "admins/logout" => "admins#logout", as: "admins_logout"
  
  #menusコントローラ
  resources :menus, only: [:new, :index, :create, :destroy]
  get "menus/choice" => "menus#choice", as: "menu_choice"
  
  #searchコントローラ
  get "search/search_index" => "search#search_index", as: "search_index"
  post "search_data" => "search#search_data", as: "search_data"
  post "strong_search" => "search#strong_search", as: "strong_search"

  #style_imagesコントローラ
  resources :style_images, only: [:edit, :update]
  post "destroy/preparation" => "style_images#destroy_preparation", as: "destroy_preparation"

  #user_cardsコントラーラ
  resources :user_cards
  resources :hairdresser_comments, only: [:edit, :show, :update, :destroy]

end
