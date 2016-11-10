module DateRange
  extend ActiveSupport::Concern

  private

    # Handle record date range
    # Params:
    #     from -> Start date
    #     to -> End date
    def dateRangeRecords
      from = params.has_key?(:from) ? params[:from] : nil
      to = params.has_key?(:to) ? params[:to] : nil

      date_attribute ||= "created_at"
      # Starting date, no ending date
      if to.nil? and !from.nil?
        @records = @records.where("#{date_attribute} >= ?", from)
      elsif from.nil? and !to.nil?
        @records = @records.where("#{date_attribute} <= ?", to)
      elsif !from.nil? and !to.nil?
        @records = @records.where("#{date_attribute} >= ? AND #{date_attribute} <= ?", from, to)
      end
    end

end
