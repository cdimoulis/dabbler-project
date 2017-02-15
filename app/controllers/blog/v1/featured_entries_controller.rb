class Blog::V1::FeaturedEntriesController < Blog::V1::BlogController
  include HasCreator
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]
  before_action :check_data, only: [:create, :update]
  before_action :set_scopes, only: [:index]

  respond_to :json

  ###
  # Standard CRUD Ops overrides
  ###
  # Featured entries are not destroyed. The 'removed' flag is set_set
  # Featured entries are deleted if their associated entry is destroyed
  def destroy
    @record = FeaturedEntry.where('id = ?',params[:id]).take
    if @record.present?
      update_attribute('removed', true)
    end
  end

  ###
  # End standard CRUD Ops overrides
  ###


  protected

  def permitted_params
    params.require(:featured_entry).permit(:author_id, :domain_id, :entry_id,
                                          {group_topic_published_entries_attributes: [:id, :group_id, :topic_id, :published_entry_id]},
                                          :image_url, :notes, :tags, :data,
                                          :current, :removed).tap do |whitelist|
      whitelist[:data] = params[:featured_entry][:data]
    end
  end

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

    if params[:removed]
      @scopes.push :removed
    else
      @scopes.push :non_removed
    end
  end
end
