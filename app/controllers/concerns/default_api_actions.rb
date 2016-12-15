module DefaultApiActions
  extend ActiveSupport::Concern

  ###
  # Standard CRUD Ops
  ###
  def create
    # TODO: Authorization
    #   Need to authorize when USERS are added
    resource_name, resource_id, parent_name, parent_id = getResources()
    @resource = resource_name.classify.constantize
    begin
      @record = @resource.new permitted_params
      # If there is a parent then add that model to the
      if !parent_name.nil? and !parent_id.nil?
        # Try block in case parent_name is not a model class
        begin
          parent = parent_name.classify.constantize
          if parent.exists?(parent_id) and @record.respond_to?(parent_name.singularize)
            @record.send("#{parent_name.singularize}=",parent.find(parent_id))
          end
        rescue NameError => e
          errors = {msg: "Possible invalid parent: #{parent_name.classify}", error: "#{e.inspect}"}
        end
      end

      if errors.nil?
        # If HasCreator is included then add creator
        if self.class.included_modules.include?(HasCreator)
          add_creator()
        end

        if @record.valid? and @record.save
          respond_with :blog, :v1, @record
        else
          puts "\n\nCould not create #{@resource} record.\n#{@record.errors.inspect}\n\n"
          Rails.logger.debug "\n\nCould not create #{@resource} record.\n#{@record.errors.inspect}\n\n"
          render :json => {errors: @record.errors}, :status => 422
        end
      else
        puts "\n\nCould not create #{@resource} record.\n#{errors.inspect}\n\n"
        Rails.logger.debug "\n\nCould not create #{@resource} record.\n#{errors.inspect}\n\n"
        render :json => {errors: errors}, :status => 422
      end

    # No model data sent
    rescue ActionController::ParameterMissing => e
      puts "\n\nCould not create #{@resource} record.\nNo attributes specified\n#{e.inspect}\n\n"
      Rails.logger.debug "\n\nCould not create #{@resource} record.\nNo attributes specified\n#{e.inspect}\n\n"
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
        parent = parent_name.classify.constantize
        # Check that the parent model with parent_id exists
        if parent.exists?(parent_id)
          parent_record = parent.find parent_id
          # Does parent respond to the singular name?
          if parent_record.respond_to?(resource_name.singularize)
            @records = [parent_record.send(resource_name.singularize)]
          # Does parent respond to the pluralized name?
          elsif parent_record.respond_to?(resource_name)
            @records = parent_record.send(resource_name)
          else
            errors = {msg: "Parent #{parent_name} does not respond to #{resource_name}"}
          end
        else
          errors = {msg: "Invalid Parent: #{parent_name} of id #{parent_id} does not exist."}
        end
      rescue NameError => e
        errors = {msg: "Invalid parent: #{parent_name}", error: "#{e}"}
      end
    else
      @resource = resource_name.classify.constantize
      @records = @resource.all
    end

    # If from or to then grab by date
    if self.class.included_modules.include?(DateRange) && ( params.has_key?(:from) || params.has_key?(:to) )
      dateRangeRecords()
    end

    # If count or start Page records
    if self.class.included_modules.include?(PageRecords) && ( params.has_key?(:count) || params.has_key?(:start) )
      pageRecords()
    end

    if errors.nil?
      respond_with :blog, :v1, @records
    else
      render :json => {errors: errors}, :status => 422
    end
  end


  def show
    resource_name, resource_id = getResources()
    @resource = resource_name.classify.constantize

    @record = @resource.where("id = ?", resource_id).take
    if @record.nil?
      render :json => {}, :status => 404
    else
      respond_with :blog, :v1, @record
    end
  end


  def update
    # TODO: Authorization
    #   Need to authorize when USERS are added
    resource_name, resource_id = getResources()
    @resource = resource_name.classify.constantize

    @record = @resource.where("id = ?", resource_id).take
    if @record.update(permitted_params)
      respond_with :blog, :v1, @record
    else
      render :json => {errors: @record.errors}, :status => 424
    end
  end


  def destroy
    # TODO: Authorization
    #   Need to authorize when USERS are added
    resource_name, resource_id = getResources()
    resource = resource_name.classify.constantize

    @record = resource.where("id = ?", resource_id).take
    if !@record.nil? and @record.destroy
      respond_with :blog, :v1, @record
    else
      render :json => {errors: @record.errors}, :status => 424
    end
  end
  ###
  # End standard CRUD Ops
  ###


  ###
  # Unused actions
  ###
  def new
    render :json => {}, :status => 405
  end

  def edit
    render :json => {}, :status => 405
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
      parent = params[:parent].to_s
    end
    resource = controller_name
    id = params[:id]

    [resource, id, parent, parent_id]
  end

  # By default, permit all except
  # id, created_at, updated_at
  def permitted_params
    remove = ['id', 'created_at', 'updated_at']
    resource = controller_name.singularize.classify.constantize
    attributes = resource.column_names
    remove.each do |a|
      attributes.delete(a)
    end

    resource.require(controller_name).permit(attributes)
  end

end
