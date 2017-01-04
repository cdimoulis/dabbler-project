class Blog::V1::EntriesController < Blog::V1::BlogController
  include PageRecords
  include DateRange
  include HasCreator

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json

  ###
  # Standard CRUD Ops overrides
  ###
  # If updating a locked entry then create a new one
  def update
    entry_id = params[:id]
    entry = Entry.where('id = ?',entry_id).take
    if !entry.locked
      super
    else
      @record = entry.dup
      @record.assign_attributes permitted_params
      if @record.valid? && @record.save
        entry.updated_entry = @record
        entry.save
        respond_with :blog, :v1, @record
      else
        puts "\n\nCould not update Entry record.\n#{@record.errors.inspect}\n\n"
        Rails.logger.debug "\n\nCould not update Entry record.\n#{@record.errors.inspect}\n\n"
        render :json => {errors: {msg: "Entry could not be updated."}}, :status => 422
      end
    end
  end

  # Entries must be flagged removed before destroy will work
  def destroy
    entry_id = params[:id]
    @record = Entry.where('id = ?',entry_id).take
    if !@record.locked
      super
    else
      if !@record.nil? && @record.remove
        super
      else
        render :json => {errors: {msg: "Entry is not flagged for removal."}}, :status => 422
      end
    end
  end

  ###
  # End standard CRUD Ops overrides
  ###

  ###
  # Association methods
  ###

  # SHOW without id for any belongs_to association
  # Get the entry of any parent model
  def entry
    parent_name, parent_id = get_parent()
    begin
      parent_model = parent_name.classify.constantize
      # Check that parent model exists
      if parent_model.exists?(parent_id)
        @parent = parent_model.find parent_id
        # Does parent respond to the singular name?
        if @parent.respond_to?(:entry)
          @record = @parent.entry
        # Does parent have entry_id
        elsif @parent.respond_to(:entry_id)
          # Does the entry exists?
          if Entry.exists?(@parent.entry_id)
            @record = Entry.find(@parent.entry_id)
          else
            errors = {msg: "Entry: Invalid Parent: #{parent_name} is not associated with entry."}
          end
        else
          errors = {msg: "Entry: Invalid Parent: #{parent_name} is not associated with entry."}
        end
      else
        errors = {msg: "Entry: Invalid Parent: #{parent_name} of id #{parent_id} does not exist."}
      end
    rescue NameError => e
      errors = {msg: "Entry: Invalid parent: #{parent_name}", error: "#{e}"}
    end

    if errors.nil?
      respond_with :blog, :v1, @record
    else
      render :json => {errors: errors}, :status => 404
    end
  end

  # Get the author of the entry
  def author
    entry_id = params[:entry_id]
    entry = Entry.where('id = ?', entry_id).take

    if entry.nil?
      render :json => {}, :status => 404
    else
      @record = entry.author
      respond_with :blog, :v1, @record
    end
  end

  # Get the contributors of the entry
  def contributors
    entry_id = params[:entry_id]
    entry = Entry.where('id = ?', entry_id).take

    if entry.nil?
      render :json => {}, :status => 404
    else
      @records = entry.contributors

      # Page the records if desired
      if params.has_key?(:count) || params.has_key?(:start)
        pageRecords()
      end

      respond_with :blog, :v1, @records
    end
  end

  ###
  # End Association methods
  ###

  protected

  def permitted_params
    params.require(:entry).permit(:text, :description, :author_id, :default_image_url,
                                  :content, :remove)
  end

end
