class Api::V1::DomainsController < Api::V1::ApiController
  before_action :require_login, only: [:create, :update, :destroy]

  ###
  # Standard CRUD Ops
  ###
  def create
    super
  end

  def index
    super
  end

  def show
    super
  end

  def update
    super
  end

  def destroy
    render :json => {  }, :status => 405
  end
  ###
  # End standard CRUD Ops
  ###

  def new
    super
  end

  def edit
    super
  end



  protected

  def permitted_params
    params.require(:domain).permit(:text, :description, :subdomain, :active)
  end

end
