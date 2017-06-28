class Blog::V1::PublishedEntriesController < Blog::V1::BlogController
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]
  before_action :check_data, only: :update
  before_action :set_scopes, only: [:index]

  respond_to :json

  ###
  # Standard CRUD Ops overrides
  ###
  # Published entries are not destroyed. The 'removed' flag is set_set
  # Published entries are deleted if their associated entry is destroyed
  def destroy
    @record = PublishedEntry.where('id = ?',params[:id]).take
    if @record.present?
      @record.update_attribute('removed', true)
      respond_with :blog, :v1, @record
    else
      render :json => {errors: @record.errors}, :status => 424
    end
  end

  ###
  # End standard CRUD Ops overrides
  ###


  protected

  def permitted_params
    params.require(:published_entry).permit(:author_id, :domain_id, :entry_id,
                                            {published_entries_topics_attributes: [:topic_id, :published_entry_id, :order]},
                                            :image_url, :notes, :tags, :data, :type,
                                            :current, :removed).tap do |whitelist|
      whitelist[:data] = params[:published_entry][:data]
    end
  end

  # Check json data on update
  def check_data
    # When updating
    if params.include?(:published_entry) and (!params[:published_entry].include?(:data) or params[:published_entry][:data].nil?)
      record = PublishedEntry.where('id = ?', params[:id]).take
      params[:published_entry][:data] = record.data
    end
  end

  def set_scopes
    @scopes = @scopes || []
    if params[:current]
      @scopes.push({scope: :current})
    end

    if params[:published]
      @scopes.push({scope: :published})
    end

    if params[:not_published]
      @scopes.push({scope: :not_published})
    end

    if params[:removed]
      @scopes.push({scope: :removed})
    else
      @scopes.push({scope: :non_removed})
    end
  end

end
