module HasCreator
  extend ActiveSupport::Concern

  included do
    before_create :add_creator
  end

  def add_creator
    if self.respond_to?(:creator_id) && !User.current.nil? &&  !User.current.id.nil?
      self.creator_id = User.current.id
    end
  end

end
