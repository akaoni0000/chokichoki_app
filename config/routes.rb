Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#user_top"
  get "hairdresser_top" => "home#hairdresser_top", as: "hairdresser_top"
  #resources :admins
  resources :style_images, only: [:edit, :update]
  post "destroy/preparation" => "style_images#destroy_preparation", as: "destroy_preparation"
  

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
 





  get "menus/choice" => "menus#choice", as: "menu_choice"
  resources :menus


  namespace :hairdressers do
    get "hairdresser_reservation" => "reservations#reservation_index", as: "reservation_index"
    get "hairdresser_cancel_reservation" => "reservations#cancel_index", as: "cancel_index"
    resources :reservations, only: [:new, :index, :create, :destroy]
  end

  namespace :users do
    get "user_reservation/:menu_id" => "reservations#reservation_index", as: "reservation_index"
    post "user_reservation/cancel/:menu_id/:start_time" => "reservations#cancel", as: "reservation_cancel"
    post "user_reservation/card_pay" => "reservations#pay", as: "card_resevation_pay"
    get "complete" => "reservations#complete", as: "complete"
    resources :reservations, only: [:edit, :update, :index]
    resources :hairdressers, only: [:show, :index]
  end

  resources :users
  post "user/login" => "users#login", as: "user_login"
  post "user/logout" => "users#logout", as: "user_logout"


  resources :hairdressers
  post "hairdresser/login" => "hairdressers#login", as: "hairdresser_login"
  post "hairdresser/logout" => "hairdressers#logout", as: "hairdresser_logout"
  get "hairdresser/wait/:id" => "hairdressers#wait", as: "hairdresser_wait"

  resources :user_cards

  resources :hairdresser_comments, only: [:edit, :show, :update, :destroy]


end
