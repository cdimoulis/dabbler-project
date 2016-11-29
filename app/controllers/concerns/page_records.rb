module PageRecords
  extend ActiveSupport::Concern

  private

  # Handle record paging
  # Params:
  #     start -> Starting record
  #     count -> Number of records to fetch
  def pageRecords
    start = params.has_key?(:start) ? params[:start] : 0
    count = params.has_key?(:count) ? params[:count] : 1000

    @records = @records.offset(start).limit(count)
  end

end
