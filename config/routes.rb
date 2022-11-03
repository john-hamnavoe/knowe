Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :users do
    resources :current_projects, only: [:update]
  end
  # Defines the root path route ("/")
  # root "articles#index"
  resources :dashboards, only: [:index]
  resources :projects, except: [:destroy]
  resources :platform_posts, only: [:index] do
    member do 
      get :post_to_platform
    end
  end


  resources :platform_customer_fetches, only: [:new, :create, :update]
  resources :platform_account_customers, only: [:index, :show] do
    resources :tabs, only: [:index], controller: "platform_customer_tabs"
    resources :contacts, only: [:index], controller: "platform_customer_contacts"
    resources :customer_sites, only: [:index], controller: "platform_customer_customer_sites"
    resources :item_rentals, only: [:index], controller: "platform_customer_item_rentals"
    resources :lift_events, only: [:index], controller: "platform_customer_lift_events"
    resources :order_items, only: [:index, :edit, :update], controller: "platform_customer_order_items"
    resources :orders, only: [:index], controller: "platform_customer_orders"
    resources :route_assignments, only: [:index], controller: "platform_customer_route_assignments"
    resources :stop_lists, only: [:index, :create], controller: "platform_customer_stop_lists"    
    namespace :customer_dashboard do
      resources :lift_events, only: [:index]   
    end
  end

  resources :platform_casual_customers, only: [:index, :show]
  
  resources :platform_notifications, only: [:index, :new]

  namespace :dashboard do
    namespace :customer do
      resources :counts, only: [:index]
    end
    namespace :lift_event do
      resources :counts, only: [:index]
      resources :activities, only: [:index]
    end
    namespace :setting do
      resources :counts, only: [:index]
    end
    namespace :service_agreement do
      resources :counts, only: [:index]
    end
  end

  resources :platform_settings, only: [:index, :new]
  namespace :platform_settings do
    resources :accounting_periods, only: [:index]
    resources :actions, only: [:index]
    resources :business_types, only: [:index]
    resources :company_outlets, only: [:index]
    resources :contact_types, only: [:index]
    resources :container_statuses, only: [:index]
    resources :container_types, only: [:index]
    resources :contract_statuses, only: [:index]
    resources :currencies, only: [:index]
    resources :customer_site_states, only: [:index]
    resources :customer_states, only: [:index]
    resources :customer_templates, only: [:index]
    resources :customer_types, only: [:index]
    resources :day_of_weeks, only: [:index]
    resources :departments, only: [:index]
    resources :default_actions, only: [:index]
    resources :direct_debit_run_configurations, only: [:index]
    resources :document_delivery_types, only: [:index]
    resources :external_vehicles, only: [:index]
    resources :invoice_cycles, only: [:index]
    resources :invoice_frequencies, only: [:index]
    resources :materials, only: [:index]
    resources :payment_points, only: [:index]
    resources :payment_terms, only: [:index]
    resources :payment_types, only: [:index]
    resources :pickup_intervals, only: [:index]
    resources :priorities, only: [:index]
    resources :route_templates, only: [:index]
    resources :schedules, only: [:index, :new]    
    resources :service_agreements, only: [:index, :show, :new]
    resources :services, only: [:index]
    resources :sic_codes, only: [:index]
    resources :vats, only: [:index]
    resources :vehicle_types, only: [:index]
    resources :vehicles, only: [:index]
    resources :weighing_types, only: [:index]
    resources :zones, only: [:index]
  end
end
