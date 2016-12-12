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
    puts "\n\nFROM TO #{from} #{to}\n\n"
    # Default attribute for paging is created_at
    date_attribute = 'created_at'

    # If a attribute for date ranging was specified
    if params.has_key?(:date_attribute)
      # If the column exists in the table
      if @resource.column_names.include?(params[:date_attribute])
        attr_type = @resource.columns_hash[params[:date_attribute]].type
        # If the type is date rangable
        if attr_type.eql?(:datetime) || attr_type.eql?(:date)
          date_attribute = params[:date_attribute]
        end
      end
    end

    # Starting date, no ending date
    if to.nil? and !from.nil?
      @records = @records.where("#{date_attribute} >= ?", from)
    # Ending date, no starting date
    elsif from.nil? and !to.nil?
      @records = @records.where("#{date_attribute} <= ?", to)
    # Starting date and ending date
    elsif !from.nil? and !to.nil?
      @records = @records.where("#{date_attribute} >= ? AND #{date_attribute} <= ?", from, to)
    end
  end

end
