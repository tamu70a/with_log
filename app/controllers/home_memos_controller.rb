# app/controllers/home_memos_controller.rb
class HomeMemosController < ApplicationController
  before_action :authenticate_user!

  def update
    home_memo = current_user.home_memo
    home_memo.update!(home_memo_params)
    render json: { status: "ok" }
  end

  private

  def home_memo_params
    params.require(:home_memo).permit(:content)
  end
end
