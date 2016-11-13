class Api::V1::PeopleController < Api::V1::ApiController
  include PageRecords

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

  # def destroy
  #   super
  # end
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
      params.require(:person).permit(:prefix, :first_name, :middle_name, :last_name,
                              :suffix, :gender, :birth_date, :phone, :address_one,
                              :address_two, :city, :state_region, :country, :postal_code,
                              :facebook_id, :facebook_link, :twitter_id, :twitter_screen_name,
                              :instagram_id, :instagram_username)
    end
end
