class Blog::V1::GroupsController < Blog::V1::BlogController
  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:group).permit(:text, :description, :domain_id, :type, :order)
  end

end
