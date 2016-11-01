###
# Parent controller for all API V1 controllers
###
class Api::V1::ApiController < ActionController::Base
  protect_from_forgery with: :exception

  respond_to :json

  ###
  # Standard CRUD Ops
  ###
  def create
    # TODO: Authorization
    #   Need to authorize when USERS are added
    puts "\nParams: #{params[:controller]}\n"
    resource = params[:controller].gsub("api/v1/","").singularize.classify.constantize
    begin
      record = resource.new permitted_params
      if record.valid? and record.save
        respond_with( record )
      else
        puts "\n\nCould not create #{resource} record.\n#{record.errors.inspect}\n\n"
        Rails.logger.debug "\n\nCould not create #{resource} record.\n#{record.errors.inspect}\n\n"
        render :json => {errors: record.errors}, :status => 422
      end
    rescue ActionController::ParameterMissing
      puts "\n\nCould not create #{resource} record.\nNo attributes specified\n\n"
      Rails.logger.debug "\n\nCould not create #{resource} record.\nNo attributes specified\n\n"
      render :json => {}, :status => 422
    end
  end

  def index

  end

  def show

  end

  def update
    # TODO: Authorization
    #   Need to authorize when USERS are added

  end

  def delete
    # TODO: Authorization
    #   Need to authorize when USERS are added

  end
  ###
  # End standard CRUD Ops
  ###

  ###
  # Unused actions
  ###
  def new
    render :json => {  }, :status => 405
  end

  def edit
    render :json => {  }, :status => 405
  end


end
