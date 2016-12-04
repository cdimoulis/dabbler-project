Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  uuid_constraints = { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i }
  exc_new_edit = [:new, :edit]

  #####
  # BLOG Routes for the database models
  #####
  namespace :blog do
    namespace :v1 do
       resources :domains, except: (exc_new_edit + [:destroy]), constraints: uuid_constraints do
         resources :domain_groups, except: exc_new_edit, parent: :domains
       end

       resources :domain_groups, except: exc_new_edit, constraints: uuid_constraints

       resources :users, except: exc_new_edit, constraints: uuid_constraints

       resources :people, except: exc_new_edit, constraints: uuid_constraints

    end
  end
  #####
  # END BLOG Routes
  #####


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
    resource :password, controller: 'auth/passwords', only: [:create, :edit, :update]
  end

  resources :passwords, controller: 'auth/passwords', only: [:create, :new]

end

# ADDITIONAL_ROUTES = Dir[Rails.root.join('config','routes','**','*.rb')]
# ADDITIONAL_ROUTES.each do |route_file|
#   require route_file
# end
