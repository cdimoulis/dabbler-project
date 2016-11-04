class Api::V1::EntriesController < Api::V1::ApiController

  respond_to :json

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
      params.require(:domain).permit()
    end
end
