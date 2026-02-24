# app/controllers/habit_checks_controller.rb
class HabitChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def create
    # 今日のチェックを作成
    @habit.habit_checks.create(check_date: Date.current)
    redirect_to root_path
  end

  def destroy
    # 今日のチェックを削除
    check = @habit.habit_checks.find_by(check_date: Date.current)
    check&.destroy
    redirect_to root_path
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end
end
