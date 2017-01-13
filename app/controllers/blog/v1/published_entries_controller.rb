class Blog::V1::PublishedEntriesController < Blog::V1::BlogController
  include HasCreator
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:published_entry).permit(:author_id, :domain_id, :entry_id,
                                            :image_url, :notes, :tags, :data, :type).tap do |whitelist|
      whitelist[:data] = params[:featured_entry][:data]
    end
  end

end
