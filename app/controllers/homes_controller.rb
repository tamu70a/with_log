# app/controllers/homes_controller.rb
class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @home_memo = current_user.home_memo || current_user.create_home_memo!
  end
end
