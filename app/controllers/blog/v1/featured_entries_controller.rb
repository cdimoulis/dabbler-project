class Blog::V1::FeaturedEntriesController < Blog::V1::BlogController
  include HasCreator
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]
  before_action :check_data, only: [:create, :update]
  before_action :set_scopes, only: [:index]

  respond_to :json

  # Check json data on update
  def check_data
    # When updating
    if params.include?(:featured_entry) and (!params[:featured_entry].include?(:data) or params[:featured_entry][:data].nil?)
      record = FeaturedEntry.where('id = ?', params[:id]).take
      params[:featured_entry][:data] = record.data
    end
  end

  def set_scopes
    @scopes = @scopes || []
    if params[:current]
      @scopes.push :current
    end
  end


  protected

  def permitted_params
    params.require(:featured_entry).permit(:author_id, :domain_id, :entry_id,
                                          {group_topic_published_entries_attributes: [:id, :group_id, :topic_id, :published_entry_id]},
                                          :image_url, :notes, :tags, :data, :current).tap do |whitelist|
      whitelist[:data] = params[:featured_entry][:data]
    end
  end
end
