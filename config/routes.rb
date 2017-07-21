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
        resources :child_orderings, only: :index, to: 'domains#child_orderings'
        # resources :featured_entries, except: exc_new_edit, parent: :domains
        # resources :menus, only: [:create, :index], parent: :domain
        # resources :menu_groups, only: :index, parent: :domains
        # resources :published_entries, only: :index, parent: :domains
        # resources :topics, only: :index, parent: :domains
      end

      resources :entries, except: exc_new_edit, constraints: uuid_constraints do
        # resource :author, to: 'users#author', only: :show, parent: :entries
        # resources :contributors, to: 'users#contributors', only: :index, parent: :entries
        # resources :featured_entries, only: [:create, :index], parent: :entries
        # resources :published_entries, only: [:create, :index], parent: :entries
      end

      resources :featured_entries, except: exc_new_edit, constraints: uuid_constraints do
        # resource :domain, only: :show, action: 'single_index', parent: :featured_entries
        # resource :entry, only: :show, action: 'single_index', parent: :featured_entries
        # resources :menu_groups, only: :index, parent: :featured_entries
        # resources :topics, only: :index, parent: :featured_entries
      end

      resources :menu_groups, except: exc_new_edit, constraints: uuid_constraints do
        resources :child_orderings, only: :index, to: 'menu_groups#child_orderings'
        # resource :domain, only: :show, action: 'single_index', parent: :menu_groups
        # resources :featured_entries, only: :index, parent: :menu_groups
        # resources :published_entries, only: :index, parent: :menu_groups
        # resources :topics, except: exc_new_edit + [:update], parent: :menu_groups
      end

      resources :menus, except: exc_new_edit, constraints: uuid_constraints do
        resources :child_orderings, only: :index, to: 'menus#child_orderings'
        # resources :menu_groups, only: :index, parent: :menus
      end

      resources :people, except: exc_new_edit, constraints: uuid_constraints

      # Only index and show.
      # Create, update, destroy done through associated FeaturedEntry or TutorialEntry
      resources :published_entries, except: exc_new_edit, constraints: uuid_constraints do
        # resource :domain, only: :show, action: 'single_index', parent: :published_entries
        # resource :entry, only: :show, action: 'single_index', parent: :published_entries
        # resources :menu_groups, only: :index, parent: :published_entries
        # resources :topics, only: :index, parent: :published_entries
      end

      resources :topics, except: exc_new_edit, constraints: uuid_constraints do
        # resource :domain, only: :show, action: 'single_index', parent: :topics
        # resources :featured_entries, only: :index, parent: :topics
        # resource :menu_group, only: :show, action: 'single_index', parent: :topics
        # resources :published_entries, only: :index, parent: :topics
      end

      resources :users, except: exc_new_edit, constraints: uuid_constraints do
        # resources :contributions, to: 'entries#contributions', only: :index, parent: :users
        # resources :entries, to: 'entries#entries', only: :index, parent: :users
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
