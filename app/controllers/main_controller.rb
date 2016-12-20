class MainController < ApplicationController
  include Clearance::Controller

  def index
    Thread.current[:user] = current_user
  end

end
