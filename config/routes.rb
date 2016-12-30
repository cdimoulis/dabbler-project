Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  uuid_constraints = { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i }
  exc_new_edit = [:new, :edit]
  exc_create_update = [:create, :update]

  root "main#index"

  #####
  # BLOG Routes for the database models
  #####
  namespace :blog do
    namespace :v1 do
      resources :domains, except: exc_new_edit + [:destroy], constraints: uuid_constraints do
        resources :groups, except: exc_new_edit, parent: :domains
        resources :featured_groups, except: exc_new_edit, parent: :domains
        resources :tutorial_groups, except: exc_new_edit, parent: :domains
        resources :topics, except: exc_new_edit + exc_create_update, parent: :domains
      end

      # We will not create a group without it being DomainGroup or TutorialGroup
      resources :groups, except: exc_new_edit + [:create], constraints: uuid_constraints do
        resources :topics, except: exc_new_edit + [:update], parent: :groups
      end

      resources :featured_groups, except: exc_new_edit, constraints: uuid_constraints do
        resources :topics, except: exc_new_edit + [:update], parent: :featured_groups
      end

      resources :tutorial_groups, except: exc_new_edit, constraints: uuid_constraints do
        resources :topics, except: exc_new_edit + [:update], parent: :tutorial_groups
      end

      resources :topics, except: exc_new_edit, constraints: uuid_constraints

      resources :users, except: exc_new_edit, constraints: uuid_constraints do
        resources :entries, to: 'users#entries', only: :index, parent: :users
        resources :contributions, to: 'users#contributions', only: :index, parent: :users
      end

      resources :people, except: exc_new_edit, constraints: uuid_constraints

      resources :entries, except: exc_new_edit, constraints: uuid_constraints do
        resource :author, to: 'entries#author', only: :show, parent: :entries
        resources :contributors, to: 'entries#contributors', only: :index, parent: :entries
      end

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
  # get '/login' => 'application#login', as: 'sign_in'
  get '/login' => 'clearance/sessions#new', as: 'sign_in'
  get '/logout' => 'clearance/sessions#destroy'
  delete '/logout' => 'clearance/sessions#destroy', as: 'sign_out'

  resources :users, only: [], constraints: uuid_constraints do
    resource :password, controller: 'auth/passwords', only: [:create, :edit, :update]
  end

  resources :passwords, controller: 'auth/passwords', only: [:create, :new]

end

# ADDITIONAL_ROUTES = Dir[Rails.root.join('config','routes','**','*.rb')]
# ADDITIONAL_ROUTES.each do |route_file|
#   require route_file
# end
