module HasCreator
  extend ActiveSupport::Concern

  def add_creator
    @record.creator_id = current_user.id
  end

end
