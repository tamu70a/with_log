class Settings::WeightGoalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @weight_goals = current_user.weight_goals.latest_first
    @weight_goal  = current_user.weight_goals.new
  end

  def create
    @weight_goal = current_user.weight_goals.new(weight_goal_params)

    if @weight_goal.save
      redirect_to settings_weight_goals_path,
                  notice: "目標を登録しました"
    else
      @weight_goals = current_user.weight_goals.latest_first
      render :index
    end
  end

  private

  def weight_goal_params
    params.require(:weight_goal).permit(:target_weight, :target_date)
  end
end
