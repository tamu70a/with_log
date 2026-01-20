class HomesController < ApplicationController
  def index
    @home_memo = current_user.home_memo || current_user.create_home_memo!(content: "")
  end
end
