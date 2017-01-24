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

  def check_group_topic_published_entries
    if params[:featured_entry][:group_topic_published_entries].nil?
      # If not models return empty array
      []
    else
      records = []
      params[:featured_entry][:group_topic_published_entries].each do |g|
        if g[:id].nil?
          # If no ID create new record
          puts "\n\nG #{g.inspect}\n\n"
          gtpe = GroupTopicPublishedEntry.new(g)
          gtpe.published_entry_id = @record.id
          if gtpe.valid? and gtpe.save
            records.push gtpe
          else
            @record.errors.add(:group_topic_published_entries, gtpe.errors)
          end
        else
          # If ID then find record
          gtpe = GroupTopicPublishedEntry.where("id = ?",g[:id]).take
          if gtpe.nil?
            @record.errors.add(:group_topic_published_entries, "Could not find model with ID #{g[:id]}")
            puts "\n\nFeaturedEntry error: Could not find model with ID #{g[:id]}\n\n"
            Rails.logger.info "\n\nFeaturedEntry error: Could not find model with ID #{g[:id]}\n\n"
          else
            records.push gtpe
          end
        end
      end
      records
    end
  end

  protected

  def permitted_params
    params.require(:featured_entry).permit(:author_id, :domain_id, :entry_id,
                                            :image_url, :notes, :tags, :data,
                                            group_topic_published_entries: self.check_group_topic_published_entries).tap do |whitelist|
      whitelist[:data] = params[:featured_entry][:data]
    end
  end
end
