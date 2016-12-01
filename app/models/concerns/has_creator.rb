module HasCreator
  extend ActiveSupport::Concern

  included do
    before_create :add_creator
  end

  def add_creator
    if self.respond_to?(:creator_id) && !current_user.nil? &&  !current_user.id.nil?
      self.creator_id = current_user.id
    end
  end

end
