class Api::V1::DomainGroupsController < Api::V1::ApiController
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
    super
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
    params.require(:domain_group).permit(:text, :description, :domain_id)
  end

end
