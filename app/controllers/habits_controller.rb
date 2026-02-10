class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: [ :edit, :update, :destroy ]
  def index
    @habits = current_user.habits.order(created_at: :desc)
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.new(habit_params)

    if @habit.save
      redirect_to habits_path, notice: "習慣を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集ページ
  def edit
  end

  # 更新処理
  def update
    if @habit.update(habit_params)
      redirect_to habits_path, notice: "習慣を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @habit.destroy
  redirect_to habits_path, notice: "習慣を削除しました"
  end

  private

  def habit_params
    params.require(:habit).permit(:title, :start_date, :end_date)
  end

  def set_habit
    # current_user の習慣からIDで取得
    @habit = current_user.habits.find(params[:id])
  end
end
