class Blog::V1::FeaturedEntriesController < Blog::V1::BlogController
  include HasCreator
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]
  before_action :check_data, only: :update

  respond_to :json

  # Check json data on update
  def check_data
    # When updating
    if !params[:featured_entry].include?(:data) or params[:featured_entry][:data].nil?
      record = FeaturedEntry.where('id = ?', params[:id]).take
      params[:featured_entry][:data] = record.data
    end
  end


  protected

  def permitted_params
    params.require(:featured_entry).permit(:author_id, :domain_id, :entry_id,
                                          {group_topic_published_entries_attributes: [:id, :group_id, :topic_id, :published_entry_id]},
                                          :image_url, :notes, :tags, :data).tap do |whitelist|
      whitelist[:data] = params[:featured_entry][:data]
    end
  end
end
