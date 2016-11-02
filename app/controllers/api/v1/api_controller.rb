###
# Parent controller for all API V1 controllers
###
class Api::V1::ApiController < ActionController::Base
  protect_from_forgery with: :exception

  respond_to :json, :html

  ###
  # Standard CRUD Ops
  ###
  def create
    # TODO: Authorization
    #   Need to authorize when USERS are added

    resource_name, resource_id, parent_name, parent_id = getResources()
    resource = resource_name.classify.constantize
    begin
      @record = resource.new permitted_params
      # If there is a parent then add that model to the
      if !parent_name.nil? and !parent_id.nil?
        # Try block in case parent_name is not a model class
        begin
          parent = parent_name.classify.constantize
          if parent.exists?(parent_id)
            @record[parent_name] = parent.find(parent_id)
          end
        rescue NameError
          errors = {msg: "Invalid parent: #{parent_name}"}
        end
      end

      if errors.nil?
        if @record.valid? and @record.save
          respond_with :api, :v1, @record
        else
          puts "\n\nCould not create #{resource} record.\n#{@record.errors.inspect}\n\n"
          Rails.logger.debug "\n\nCould not create #{resource} record.\n#{@record.errors.inspect}\n\n"
          render :json => {errors: @record.errors}, :status => 422
        end
      else
        puts "\n\nCould not create #{resource} record.\n#{errors.inspect}\n\n"
        Rails.logger.debug "\n\nCould not create #{resource} record.\n#{errors.inspect}\n\n"
        render :json => {errors: errors}, :status => 422
      end

    # No model data sent
    rescue ActionController::ParameterMissing
      puts "\n\nCould not create #{resource} record.\nNo attributes specified\n\n"
      Rails.logger.debug "\n\nCould not create #{resource} record.\nNo attributes specified\n\n"
      render :json => {}, :status => 422
    end
  end


  def index
    resource_name, resource_id, parent_name, parent_id = getResources()
    @records = []
    # fetch from parent
    if !parent_name.nil? and !parent_id.nil?
      # Try block in case parent_name is not a model class
      begin
        parent = parent.classify.constantize
        # Check that the parent model with parent_id exists
        if parent.exists?(parent_id)
          parent_record = parent.find parent_id
          # Does parent respond to the singular name?
          if parent.respond_to?(resource_name)
            @records = [parent[resource_name]]
          # Does parent respond to the pluralized name?
          elsif parent.responds_to?(resource_name.pluralize)
            @records = parent[resource_name.pluralize]
          else
            errors = {msg: "Parent #{parent_name} does not respond to #{resource_name}"}
          end
        end
      rescue NameError
        errors = {msg: "Invalid parent: #{parent_name}"}
    else
      resource = resource_name.classify.constantize
      @records = resource.all
    end

    # If from or to then grab by date
    if params.has_key?(:from) or params.has_key?(:to)
      dateRangeRecords()
    end

    # If count or start Page records
    if params.has_key?(:count) or params.has_key?(:start)
      pageRecords()
    end

    if errors.nil?
      respond_with :api, :v1, @records
    else
      respond_with :json => {errors: errors}, :status => 422
  end


  def show
    resource_name, resource_id, parent_name, parent_id = getResources()
    resource = resource_name.classify.constantize

    @record = resource.where("id = ?", resource_id).take
    if @record.nil?
      render :json => {}, :status => 404
    else
      respond_with :api, :v1, @record
    end
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
  ###
  # End Unused actions
  ###

  protected

    # Get the resources for the request
    # This returns an array of model data
    # [resource_name, resource_id, parent_name, parent_id]
    def getResources
      if params.has_key?(:parent)
        id_string = "#{params[:parent].to_s.singularize}_id"
        parent_id = params[id_string]
        parent = params[:parent].to_s.singularize
      end
      resource = controller_name.singularize
      id = params[:id]

      [resource, id, parent, parent_id]
    end

    # Handle record date range
    # Params:
    #     from -> Start date
    #     to -> End date
    def dateRangeRecords()
      from = params.has_key?(:from) ? params[:from] : nil
      to = params.has_key?(:to) ? params[:to] : nil

      date_attribute ||= "created_at"
      # Starting date, no ending date
      if to.nil? and !from.nil?
        @records = @records.where("#{date_attribute} >= ?", from)
      elsif from.nil? and !to.nil?
        @records = @records.where("#{date_attribute} <= ?", to)
      elsif !from.nil? and !to.nil?
        @records = @records.where("#{date_attribute} >= ? AND #{date_attribute} <=", from, to)
      end
    end

    # Handle record paging
    # Params:
    #     start -> Starting record
    #     count -> Number of records to fetch
    def pageRecords()
      start = params.has_key?(:start) ? params[:start] : 0
      count = params.has_key?(:count) ? params[:count] : 1000

      @records = @records.offset(start).limit(count)
    end



  private


end
