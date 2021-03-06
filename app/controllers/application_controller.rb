class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  hide_action :sign_in

  #######
  # AUTH methods
  #######

  def sign_in(user)
    super user
    if !user.nil?
      Thread.current[:user] = user
      user.last_sign_in_at = DateTime.now
      user.last_sign_in_ip = request.remote_ip
      user.save
    end
  end

  def sign_out
    Thread.current[:user] = nil
    super
  end

  def login
    render template: 'main/login'
  end
end
