module HasCreator
  extend ActiveSupport::Concern

  def add_creator
    if @record.respond_to?(:creator_id) && @record.creator_id.nil? && !current_user.nil? &&  !current_user.id.nil?
      @record.creator_id = current_user.id
    end
  end

end
