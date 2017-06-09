class Blog::V1::EntriesController < Blog::V1::BlogController
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]
  before_action :set_scopes, only: [:index]

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
      if entry.updated_entry_id.present?
        puts "\n\nCould not update Entry record: Record has been previously updated\n\n"
        Rails.logger.debug "\n\nCould not update Entry record: Record has been previously updated\n\n"
        render :json => {errors: {msg: "Entry could not be updated: Record has been previously updated"}}, :status => 422
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
  end

  # Entries must be flagged removed before destroy will work
  def destroy
    entry_id = params[:id]
    @record = Entry.where('id = ?',entry_id).take
    if !@record.locked
      super
    else
      if @record.present? && @record.remove
        # Remove all published_entries
        PublishedEntry.where(entry_id: @record.id).each do |pe|
          pe.destroy
        end
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

  # Get the entries this user is author of
  def entries
    user_id = params[:user_id]
    user = User.where('id = ?', user_id).take

    if user.nil?
      render :json => {}, :status => 404
    else
      @records = user.entries

      # Page the records if desired
      if params.has_key?(:count) || params.has_key?(:start)
        pageRecords()
      end

      respond_with :blog, :v1, @records
    end
  end

  # Get the entries this user is a contributor of
  def contributions
    user_id = params[:user_id]
    user = User.where('id = ?', user_id).take

    if user.nil?
      render :json => {}, :status => 404
    else
      @records = user.contributions

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
                                  :content, :remove, :unpublished)
  end

  def set_scopes
    @scopes = @scopes || []
    if params[:unpublished]
      @scopes.push {scope: :unpublished}
    end
  end

end
