class Blog::V1::EntriesController < Blog::V1::BlogController
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


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
