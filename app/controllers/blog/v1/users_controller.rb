class Blog::V1::UsersController < Clearance::UsersController
  include DefaultApiActions
  include PageRecords

  before_action :require_login, only: [:update, :destroy]

  respond_to :json

  # Get the author of the entry
  def entries
    user_id = params[:user_id]
    user = User.where('id = ?', user_id).take

    if user.nil?
      render :json => {}, :status => 404
    else
      @records = user.entries
      respond_with :blog, :v1, @records
    end
  end

  # Get the contributors of the entry
  def contributions
    user_id = params[:user_id]
    user = User.where('id = ?', user_id).take

    if user.nil?
      render :json => {}, :status => 404
    else
      @records = user.contributions
      respond_with :blog, :v1, @records
    end
  end

  ###
  # Standard CRUD Ops overrides
  ###
  def create
    @record = User.new permitted_params

    if @record.valid? and @record.save
      respond_with :blog, :v1, @record
    else
      render :json => {errors: @record.errors}, :status => 422
    end
  end

  ###
  # End standard CRUD Ops overrides
  ###


  protected

  def permitted_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                  :prefix, :first_name, :middle_name, :last_name, :suffix, :gender,
                  :birth_date, :phone, :address_one, :address_two, :city, :state_region,
                  :country, :postal_code, :facebook_id, :facebook_link, :twitter_id,
                  :twitter_screen_name, :instagram_id, :instagram_username, :person_id)
  end


  private

  def redirect_signed_in_users
    # As this controller is part of the API we do not want to redirect
    # users. In fact a signed in user may create a new user
    # Thus we are overriding this with no operations
  end

end
