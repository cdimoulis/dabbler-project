module DefaultApiActions
  extend ActiveSupport::Concern

  ###
  # Standard CRUD Ops
  ###
  def create
    # resource_name: model being created
    # resource_id: id of model being created
    # parent_name: model of parent if nested url
    # parent_id: id of parent model if nested url
    resource_name, resource_id, parent_name, parent_id = get_resources()
    # Collect errors to know how to return
    @errors = {}
    # The class of the model being created
    @resource = resource_name.classify.constantize
    # Try block in case no attributes are specified
    begin
      # Create the new record
      @record = @resource.new permitted_params
      # If there is a parent then add that model to the
      if !parent_name.nil? and !parent_id.nil?
        # Try block in case parent_name is not a model class
        begin
          # The class of the parent model
          parent_model = parent_name.classify.constantize
          # If the parent_id is a model and the new model responds to (has anssociation with) the parent
          if parent_model.exists?(parent_id) and @record.respond_to?(parent_name.singularize)
            @parent = parent_model.find(parent_id)
            @record.send("#{parent_name.singularize}=", @parent)
          end
        rescue NameError => e
          puts "\n\nPossible invalid parent: #{parent_name.classify}", error: "#{e.inspect}\n\n"
          Rails.logger.debug "\n\nPossible invalid parent: #{parent_name.classify}", error: "#{e.inspect}\n\n"
          @errors[:msg] = "Possible invalid parent: #{parent_name.classify}"
        end
      end

      # If responds_to creator_id then add creator
      # This may be redundant to the model concern SetCreator
      # but I'm considering this as a backup to that before_create callback
      if @record.respond_to?(:creator_id) && @record.creator_id.nil? && !current_user.nil? && !current_user.id.nil? && self.class.included_modules.include?(HasCreator)
        add_creator()
      end

      # If no errors have occurred yet then proceed with save
      if @errors.empty?
        # Perform the save if the new model is valid
        if @record.valid? and @record.save
          respond_with :blog, :v1, @record
        else
          puts "\n\nCould not create #{@resource} record.\n#{@record.errors.inspect}\n\n"
          Rails.logger.debug "\n\nCould not create #{@resource} record.\n#{@record.errors.inspect}\n\n"
          render :json => {errors: @record.errors}, :status => 422
        end
      else
        puts "\n\nCould not create #{@resource} record.\n#{@errors.inspect}\n\n"
        Rails.logger.debug "\n\nCould not create #{@resource} record.\n#{@errors.inspect}\n\n"
        render :json => {errors: @errors}, :status => 422
      end

    # No model data sent
    rescue ActionController::ParameterMissing => e
      puts "\n\nCould not create #{@resource} record.\nNo attributes specified\n#{e.inspect}\n\n"
      Rails.logger.debug "\n\nCould not create #{@resource} record.\nNo attributes specified\n#{e.inspect}\n\n"
      render :json => {}, :status => 422
    end
  end


  def index
    # resource_name: model being created
    # resource_id: id of model being created
    # parent_name: model of parent if nested url
    # parent_id: id of parent model if nested url
    resource_name, resource_id, parent_name, parent_id = get_resources()
    # Records to return
    @records = []
    # Collect errors to know how to return
    @errors = {}
    # fetch from parent
    if !parent_name.nil? and !parent_id.nil?
      # Rescue block in case parent_name is not a model class
      begin
        # The class of the parent model
        parent_model = parent_name.classify.constantize
        # Check that the parent model with parent_id exists
        if parent_model.exists?(parent_id)
          @parent = parent_model.find parent_id
          # Does parent respond to the singular name?
          if @parent.respond_to?(resource_name.singularize)
            @records = [@parent.send(resource_name.singularize)]
          # Does parent respond to the pluralized name?
          elsif @parent.respond_to?(resource_name)
            @records = @parent.send(resource_name)
          else
            puts "\n\nParent #{parent_name} does not respond to #{resource_name}\n\n"
            Rails.logger.debug "\n\nParent #{parent_name} does not respond to #{resource_name}\n\n"
            @errors[:msg] = "Parent #{parent_name} does not respond to #{resource_name}"
          end
        else
          puts "\n\nInvalid Parent: #{parent_name} of id #{parent_id} does not exist.\n\n"
          Rails.logger.debug "\n\nInvalid Parent: #{parent_name} of id #{parent_id} does not exist.\n\n"
          @errors[:msg] = "Invalid Parent: #{parent_name} of id #{parent_id} does not exist."
        end
      rescue NameError => e
        puts "\n\nInvalid parent: #{parent_name}", error: "#{e}\n\n"
        Rails.logger.debug "\n\nInvalid parent: #{parent_name}", error: "#{e}\n\n"
        @errors[:msg] = "Invalid parent: #{parent_name}"
      end
    else
      @resource = resource_name.classify.constantize
      @records = @resource.all
    end

    # Add any specified scopes
    # Scopes should be added to @scopes before index occurs
    if @scopes.present?
      @scopes.each do |s|
        if @records.respond_to?(s[:scope])
          if s[:params].present?
            @records = @records.send(s[:scope], *s[:params])
          else
            @records = @records.send(s[:scope])
          end
        end
      end
    end

    # If DateRange concern is included and from or to is in params then grab by date
    if self.class.included_modules.include?(DateRange) && ( params.has_key?(:from) || params.has_key?(:to) )
      dateRangeRecords()
    end

    # If PageRecords concern is included and count or start is in params then page records
    if self.class.included_modules.include?(PageRecords) && ( params.has_key?(:count) || params.has_key?(:start) )
      pageRecords()
    end

    if @errors.empty?
      respond_with :blog, :v1, @records
    else
      puts "\n\nIndex error for #{@resource} record.\n#{@errors.inspect}\n\n"
      Rails.logger.debug "\n\nIndex error for #{@resource} record.\n#{@errors.inspect}\n\n"
      render :json => {errors: @errors}, :status => 422
    end
  end


  def single_index
    # resource_name: model being created
    # resource_id: id of model being created
    # parent_name: model of parent if nested url
    # parent_id: id of parent model if nested url
    resource, resource_id, parent_name, parent_id = get_resources()
    # Singularize for route naming convention
    resource_name = resource.singularize
    # The class of the model being created
    @resource = resource_name.classify.constantize
    # The attribute that should be used to to acess the id
    id_text = "#{resource_name}_id"
    # Collect errors to know how to return
    @errors = {}

    begin
      # The class of the parent model
      parent_model = parent_name.classify.constantize
      # Check that parent model exists
      if parent_model.exists?(parent_id)
        @parent = parent_model.find parent_id
        # Does parent respond to the singular name?
        if @parent.respond_to?(resource_name)
          @record = @parent.send(resource_name)
        # Does parent have #{record}_id
        elsif @parent.respond_to?(id_text.to_sym)
          # Does the record exists?
          if @resource.exists?(@parent.send(id_text))
            @record = @resource.find(@parent.send(id_text))
          else
            puts "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}.\n\n"
            Rails.logger.debug "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}.\n\n"
            @errors[:msg] = "#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}."
          end
        else
          puts "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}.\n\n"
          Rails.logger.debug "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}.\n\n"
          @errors[:msg] = "#{resource_name.classify}: Invalid Parent: #{parent_name} is not associated with #{resource_name}."
        end
      else
        puts "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} of id ''#{parent_id}'' does not exist.\n\n"
        Rails.logger.debug "\n\n#{resource_name.classify}: Invalid Parent: #{parent_name} of id '#{parent_id}' does not exist.\n\n"
        @errors[:msg] = "#{resource_name.classify}: Invalid Parent: #{parent_name} of id '#{parent_id}' does not exist."
      end
    rescue NameError => e
      puts "\n\n#{resource_name.classify}: Invalid parent: #{parent_name}", error: "#{e}\n\n"
      Rails.logger.debug "\n\n#{resource_name.classify}: Invalid parent: #{parent_name}", error: "#{e}\n\n"
      @errors[:msg] = "#{resource_name.classify}: Invalid parent: #{parent_name}"
    end

    if @errors.empty?
      respond_with :blog, :v1, @record
    else
      puts "\n\nSingle Index error for #{@resource} record.\n#{@errors.inspect}\n\n"
      Rails.logger.debug "\n\nSingle Index error for #{@resource} record.\n#{@errors.inspect}\n\n"
      render :json => {errors: @errors}, :status => 404
    end
  end


  def show
    # resource_name: model being created
    # resource_id: id of model being created
    resource_name, resource_id = get_resources()
    # The class of the model being created
    @resource = resource_name.classify.constantize
    @record = @resource.where("id = ?", resource_id).take

    if @record.nil?
      render :json => {}, :status => 404
    else
      respond_with :blog, :v1, @record
    end
  end


  def update
    # resource_name: model being created
    # resource_id: id of model being created
    resource_name, resource_id = get_resources()
    # The class of the model being created
    @resource = resource_name.classify.constantize
    @record = @resource.where("id = ?", resource_id).take

    if !@record.nil? and @record.update(permitted_params)
      respond_with :blog, :v1, @record
    else
      render :json => {errors: @record.errors}, :status => 424
    end
  end


  def destroy
    # resource_name: model being created
    # resource_id: id of model being created
    resource_name, resource_id = get_resources()
    # The class of the model being created
    @resource = resource_name.classify.constantize

    @record = @resource.where("id = ?", resource_id).take
    if @record.present?
      if @record.destroy
        respond_with :blog, :v1, @record
      else
        render :json => {errors: @record.errors}, :status => 424
      end
    else
      render :json => {errors: {msg: "Record not found"}}, :status => 404
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
  def get_resources
    parent_info = get_parent()
    resource = controller_name
    id = params[:id]

    [resource, id] + parent_info
  end

  def get_parent
    if params.has_key?(:parent)
      id_string = "#{params[:parent].to_s.singularize}_id"
      parent_id = params[id_string]
      parent = params[:parent].to_s
    end
    [parent, parent_id]
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
