Rails.application.routes.draw do
  uuid_constraints = { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i }
  exc_new_edit = [:new, :edit]

  #####
  # Session Routes
  #####
  resource :session, controller: 'clearance/sessions', only: [:create, :destroy]

  # TEMP SIGN IN FOR TESTING (actually so that sign out redirect properly)
  # Either the url after sign out needs to change (currently it is sign_in below)
  # or we just don't redirect (which will probably require extending the sessions
  # controller)
  get '/login' => 'application#login', as: 'sign_in'

  resources :users, only: [], constraints: uuid_constraints do
    resource :password, controller: 'clearance/passwords', only: [:create, :edit, :update]
  end

  resources :passwords,
    controller: 'clearance/passwords',
    only: [:create, :new]
end
