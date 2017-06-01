class Blog::V1::MenuGroupsController < Blog::V1::BlogController
  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:menu_group).permit(:text, :description, :domain_id, :menu_id,
                                      :order)
  end

end
