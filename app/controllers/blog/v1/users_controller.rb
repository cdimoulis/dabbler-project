class Blog::V1::UsersController < Clearance::UsersController
  include DefaultApiActions
  include PageRecords

  before_action :require_login, only: [:update, :destroy]

  respond_to :json


  ###
  # Association methods
  ###

  # Get the author of the entry
  def author
    entry_id = params[:entry_id]
    entry = Entry.where('id = ?', entry_id).take

    if entry.nil?
      render :json => {}, :status => 404
    else
      @record = entry.author
      respond_with :blog, :v1, @record
    end
  end

  # Get the contributors of the entry
  def contributors
    entry_id = params[:entry_id]
    entry = Entry.where('id = ?', entry_id).take

    if entry.nil?
      render :json => {}, :status => 404
    else
      @records = entry.contributors

      # Page the records if desired
      if params.has_key?(:count) || params.has_key?(:start)
        pageRecords()
      end

      respond_with :blog, :v1, @records
    end
  end

  ###
  # End Association methods
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
