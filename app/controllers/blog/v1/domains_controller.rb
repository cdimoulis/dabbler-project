class Blog::V1::DomainsController < Blog::V1::BlogController
  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  def destroy
    render :json => {  }, :status => 405
  end


  protected

  def permitted_params
    params.require(:domain).permit(:text, :description, :subdomain, :active)
  end

end
