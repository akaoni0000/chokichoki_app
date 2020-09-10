Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  #homeコントローラ
  root "home#user_top"
  get "hairdresser_top" => "home#hairdresser_top", as: "hairdresser_top"
  get "about" => "home#about", as: "about"
  get "deadline" => "home#deadline", as: "deadline"
  
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
  resources :users, only: [:edit, :create, :update]
  post "user/resend" => "users#resend", as: "user_resend"
  patch "user/password" => "users#password_update", as: "user_password_update"
  post "user/login" => "users#login", as: "user_login"
  post "user/logout" => "users#logout", as: "user_logout"
  get "user/activation" => "users#activation", as: "user_activation"
  get "user/sex_choice" => "users#sex_choice", as: "sex_choice"
  post "user/twitter_create" => "users#twitter_create", as: "twitter_create"
  post "user/guide" => "users#guide", as: "user_guide"
  post "user/password_reset" => "users#password_reset", as: "user_password_reset"
  get "user/password_update_as_forget" => "users#password_update_as_forget", as: "user_password_update_as_forget"
  patch "user/password_update_when_not_login" => "users#password_update_when_not_login", as: "user_password_update_when_not_login"

  #twitter認証のコールバック
  get '/auth/:provider/callback' => 'users#twitter' #url入力だとrootにいく
  get "/auth/failure", :to => 'users#twitter_failure' #この書き方にしないとhomesコントローラを探しにいく

  #hairdressers::reservationsコントローラ namespaceを使う時は使っていないものより上に書く 思い通りのrutingにならないerrorがでた
  namespace :hairdressers do
    get "set_week_calendar_reservation" => "reservations#set_week_calendar_reservation", as: "set_week_calendar_reservation"
    post "create_destroy_reservation" => "reservations#create_destroy_reservation", as: "create_destroy_reservation"
    get "set_month_calendar_reservation" => "reservations#set_month_calendar_reservation", as: "set_month_calendar_reservation"
    get "calendar_index" => "reservations#calendar_index", as: "calendar_index"
    post "calendar_show" => "reservations#calendar_show", as: "calendar_show"
    resources :reservations, only: [:new, :index, :create, :destroy]
    get "cancel_index" => "reservations#cancel_index", as: "cancel_index"
  end

  #hairdressersコントローラ
  resources :hairdressers, only: [:show, :edit, :index, :create, :update]
  post "hairdresser/resend" => "hairdressers#resend", as: "hairdresser_resend"
  patch "hairdresser/password" => "hairdressers#password_update", as: "hairdresser_password_update"
  post "hairdresser/login" => "hairdressers#login", as: "hairdresser_login"
  post "hairdresser/logout" => "hairdressers#logout", as: "hairdresser_logout"
  get "hairdresser/wait/:id" => "hairdressers#wait", as: "hairdresser_wait"
  get "hairdresser/activation" => "hairdressers#activation", as: "hairdresser_activation"
  post "hairdresser/guide" => "hairdressers#guide", as: "hairdresser_guide"
  post "hairdresser/password_reset" => "hairdressers#password_reset", as: "hairdresser_password_reset"
  get "hairdresser/password_update_as_forget" => "hairdressers#password_update_as_forget", as: "hairdresser_password_update_as_forget"
  patch "hairdresser/password_update_when_not_login" => "hairdressers#password_update_when_not_login", as: "hairdresser_password_update_when_not_login"

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
  resources :menus, only: [:new, :index, :create, :edit, :update]
  post "menus/status_down" => "menus#status_down", as: "status_down"
  get "menus/preparation" => "menus#preparation", as: "preparation"
  post "menus/status_update" => "menus#status_update", as: "status_update"
  get "menus/choice" => "menus#choice", as: "menu_choice"
  
  #searchコントローラ
  get "search/search_index" => "search#search_index", as: "search_index"
  post "search/top_hairdresser" => "search#top_hairdresser", as: "top_hairdresser"
  post "search_data" => "search#search_data", as: "search_data"
  get "search_data" => "search#search_data"
  post "strong_search" => "search#strong_search", as: "strong_search"
  get "strong_search" => "search#strong_search"
  post "today_hairdresser_and_menu" => "search#today_hairdresser_and_menu", as: "today_hairdresser_and_menu"
  post "tomorrow_hairdresser_and_menu" => "search#tomorrow_hairdresser_and_menu", as: "tomorrow_hairdresser_and_menu"

  #style_imagesコントローラ
  resources :style_images, only: [:edit, :update]
  post "destroy/preparation" => "style_images#destroy_preparation", as: "destroy_preparation"

  #user_cardsコントラーラ
  resources :user_cards, only: [:create, :destroy]
  
  #hairdresser_commentsコントローラ
  resources :hairdresser_comments, only: [:edit, :update, :index]

  #chatコントローラ
  get "user_chat" => "chats#user_chat", as: "user_chat"
  get "hairdresser_chat" => "chats#hairdresser_chat", as: "hairdresser_chat"
  post "message_create" => "chats#message_create", as: "message_create"
  post "receive_message" => "chats#receive_message", as: "receive_message"
  post "room" => "chats#room", as: "room"
  post "notification" => "chats#notification"
  post "chat_room_search" => "chats#chat_room_search", as: "chat_room_search"

  #favoritesコントローラ
  resources :favorites, only: [:index, :create, :destroy]

  #通知コントローラ
  post "notice/message" => "notices#notice_message_modal", as: "notice_message_modal" 
  post "notice/reservation" => "notices#notice_reservation_modal", as: "notice_reservation_modal" 
  post "notice/cancel" => "notices#notice_cancel_modal", as: "notice_cancel_modal" 

  mount ActionCable.server => '/cable'
end
