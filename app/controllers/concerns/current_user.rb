module CurrentUser
  extend ActiveSupport::Concern

  # Before any action check that current user is known
  included do
    before_action :check_current_user
  end


  private

  # Place current user in the current thread hash
  def check_current_user
    if !current_user.nil?
      Thread.current[:user] = current_user
    end
  end


end
