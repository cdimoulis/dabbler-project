class Blog::V1::EntriesController < Blog::V1::BlogController
  include PageRecords
  include DateRange
  include HasCreator

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json

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
      respond_with :blog, :v1, @records
    end
  end

  # Entries must be flagged removed before destroy will work
  def destroy
    entry_id = params[:id]
    record = Entry.where('id = ?',entry_id).take
    if !record.nil? && record.remove
      super
    else
      render :json => {errors: {msg: "Entry is not flagged for removal."}}, :status => 422
    end
  end

  protected

  def permitted_params
    params.require(:entry).permit(:text, :description, :author_id, :default_image_url,
                                  :content, :remove)
  end

end
