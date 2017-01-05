class Blog::V1::DomainsController < Blog::V1::BlogController
  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json

  ###
  # Standard CRUD Ops overrides
  ###

  def destroy
    render :json => {  }, :status => 405
  end

  ###
  # End standard CRUD Ops overrides
  ###

  ###
  # Association methods
  ###
  

  ###
  # End Association methods
  ###
  protected

  def permitted_params
    params.require(:domain).permit(:text, :description, :subdomain, :active)
  end

end
