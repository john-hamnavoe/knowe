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
  resources :settings, only: [:index]
  resources :projects, except: [:destroy]

  resources :platform_customers, only: [:index, :create, :show] do
    resources :tabs, only: [:index], controller: "platform_customer_tabs"
    resources :customer_sites, only: [:index], controller: "platform_customer_customer_sites"
    resources :orders, only: [:index], controller: "platform_customer_orders"
    resources :route_assignments, only: [:index], controller: "platform_customer_route_assignments"
    resources :item_rentals, only: [:index], controller: "platform_customer_item_rentals"
    resources :order_items, only: [:index], controller: "platform_customer_order_items"
  end

  namespace :platform_settings do
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
    resources :service_agreements, only: [:index, :show, :create]
    resources :services, only: [:index]
    resources :vats, only: [:index]
    resources :weighing_types, only: [:index]
    resources :zones, only: [:index]
  end
end
