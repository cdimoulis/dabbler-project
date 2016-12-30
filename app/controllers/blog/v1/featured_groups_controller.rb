class Blog::V1::FeaturedGroupsController < Blog::V1::BlogController
  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:featured_group).permit(:text, :description, :domain_id)
  end

end
