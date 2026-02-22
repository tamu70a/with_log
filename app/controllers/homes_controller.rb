# app/controllers/homes_controller.rb
class HomesController < ApplicationController
  before_action :authenticate_user!

  def index

    # タスクと習慣の取得
    @tasks = current_user.tasks.order(created_at: :desc)
    @habits = current_user.habits.order(created_at: :desc)

    # 習慣の日付補完
    @habits.each do |habit|
      habit.start_date ||= Date.current
      habit.end_date ||= Date.current
    end

    # ホームメモの取得または作成
    @home_memo = current_user.home_memo || current_user.create_home_memo!
    @latest_goal = current_user.weight_goals.latest_first.first
    @latest_body_record = current_user.body_records.latest_first.first

    @message = current_user.buddy_message
end
end
