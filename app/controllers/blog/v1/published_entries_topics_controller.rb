class Blog::V1::PublishedEntriesTopicsController < Blog::V1::BlogController
  include HasOrdering

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:published_entries_topic).permit(:published_entry_id, :topic_id, :order)
  end

end
