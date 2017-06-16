class Blog::V1::TopicsController < Blog::V1::BlogController

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:topic).permit(:text, :description, :domain_id, :menu_group_id)
  end

end
