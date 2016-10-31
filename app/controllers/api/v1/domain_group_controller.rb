class Api::V1::DomainGroupController < ApplicationController

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

  def delete
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



  private

    def permitted_params
      params.require(:domain_groups).permit(:text, :description, :subdomain, :active)
    end
end
