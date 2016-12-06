class Blog::V1::PeopleController < Blog::V1::BlogController
  include PageRecords

  before_action :require_login, only: [:update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:person).permit(:prefix, :first_name, :middle_name, :last_name,
                            :suffix, :gender, :birth_date, :phone, :address_one,
                            :address_two, :city, :state_region, :country, :postal_code,
                            :facebook_id, :facebook_link, :twitter_id, :twitter_screen_name,
                            :instagram_id, :instagram_username)
  end

end
