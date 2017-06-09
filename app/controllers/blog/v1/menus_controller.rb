class Blog::V1::MenusController < Blog::V1::BlogController
  include HasOrdering

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json

  protected

  def permitted_params
    params.require(:menu).permit(:text, :description, :domain_id, :order)
  end
end
