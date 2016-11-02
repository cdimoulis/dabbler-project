Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  uuid_constraints = { id: /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i }
  exc_new_edit = [:new, :edit]

  #####
  # API Routes for the database models
  #####
  # scope module: :api do
  #   scope module: :v1 do
  # scope :api do
  #   scope :v1 do
  namespace :api do
    namespace :v1 do
       resources :domains, except: (exc_new_edit + [:destroy]), constraints: uuid_constraints do
         resources :domain_groups, except: exc_new_edit
       end



    end
  end
  #####
  # END API Routes
  #####



end
