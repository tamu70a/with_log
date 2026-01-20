class HomesController < ApplicationController
  def index
    @home_note = current_user.home_note || current_user.create_home_note!(content: "")
  end
end
