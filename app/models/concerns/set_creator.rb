module SetCreator
  extend ActiveSupport::Concern

  included do
    before_create :set_creator
  end

  def set_creator
    if self.creator_id.nil?
      creator = User.current
      if creator.present?
        self.creator_id = creator.id
      end
    end
  end

end
