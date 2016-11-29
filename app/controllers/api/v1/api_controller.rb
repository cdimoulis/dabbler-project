###
# Parent controller for all API V1 controllers
###
class Api::V1::ApiController < ActionController::Base
  include Clearance::Controller
  include DefaultApiActions
  include DateRange
  include PageRecords
  # protect_from_forgery with: :exception

  respond_to :json, :html

  #####
  # All CRUD actions have been moved to the DefaultApiActions concern
  #####

  protected


  private


end
