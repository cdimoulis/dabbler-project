class Blog::V1::TopicsController < Blog::V1::BlogController
  include HasOrdering

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:topic).permit(:text, :description, :menu_group_id,
                                  :order, published_entry_ordering: [])
  end

end
