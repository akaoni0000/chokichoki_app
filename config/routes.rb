Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#top"
  #resources :admins

  resources :hairdressers
  post "hairdresser/login" => "hairdressers#login", as: "hairdresser_login"
  post "hairdresser/logout" => "hairdressers#logout", as: "hairdresser_logout"
  get "hairdresser/wait" => "hairdressers#wait", as: "hairdresser_wait"

  namespace :admins do
    resources :hairdressers
    get "hairdresser_judge_index" => "hairdressers#hairdresser_judge_index"
    post "hairdresser/permit/:id" => "hairdressers#permit", as: "hardresser_permit"
  end

  get "menus/choice" => "menus#choice", as: "menu_choice"
  resources :menus


  namespace :hairdressers do
    get "hairdresser_reservation/:menu_id" => "reservations#reservation_index", as: "reservation_index"
    resources :reservations, only: [:new, :create, :destroy]
  end

  namespace :users do
    get "user_reservation/:menu_id" => "reservations#reservation_index", as: "reservation_index"
    post "user_reservation/cancel/:menu_id/:start_time" => "reservations#cancel", as: "reservation_cancel"
    post "user_reservation/card_pay" => "reservations#pay", as: "card_resevation_pay"
    get "complete" => "reservations#complete", as: "complete"
    resources :reservations, only: [:edit, :update]
  end

  resources :users
  post "user/login" => "users#login", as: "user_login"
  post "user/logout" => "users#logout", as: "user_logout"

  resources :user_cards

  
  

end
