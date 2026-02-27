class Settings::WeightGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weight_goal, only: [ :edit, :update, :destroy ]

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
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @weight_goal.update(weight_goal_params)
      redirect_to settings_weight_goals_path,
                  notice: "目標を更新しました"
    else
      @weight_goals = current_user.weight_goals.latest_first
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @weight_goal.destroy
    redirect_to settings_weight_goals_path,
                notice: "目標を削除しました"
  end

  private

  def set_weight_goal
    @weight_goal = current_user.weight_goals.find(params[:id])
  end

  def weight_goal_params
    params.require(:weight_goal).permit(:target_weight, :target_date)
  end
end
