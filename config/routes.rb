Rails.application.routes.draw do
  root "home#index"
  resources :persons

  get 'select', to: 'select_sql#index'
  get 'where', to: 'where_sql#index'
  get 'inner_join', to: 'join_sql#index_inner_join'
  get 'outer_join', to: 'join_sql#index_outer_join'
  get 'union', to: 'union#index'
  get 'group', to: 'group_sql#index'
  get 'transaction', to: 'transaction#update'
end
