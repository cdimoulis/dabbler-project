class Api::V1::UsersController < Clearance::UsersController
  include DefaultApiActions

  respond_to :json, :html

  ###
  # Standard CRUD Ops
  ###
  def create
    puts "\n\nCREATE USER\n\n"

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
    render :json => {  }, :status => 405
  end

  def edit
    render :json => {  }, :status => 405
  end



  protected

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                    :prefix, :first_name, :middle_name, :last_name, :suffix, :gender,
                    :birth_date, :phone, :address_one, :address_two, :city, :state_region,
                    :country, :postal_code, :facebook_id, :facebook_link, :twitter_id,
                    :twitter_screen_name, :instagram_id, :instagram_username, :person_id)
    end


end
