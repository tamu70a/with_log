# app/controllers/homes_controller.rb
class HomesController < ApplicationController
  before_action :authenticate_user!

# app/controllers/homes_controller.rb
def index
  # 先にデータを全部ロードする
  @tasks = current_user.tasks.order(created_at: :desc)
  @habits = current_user.habits.order(created_at: :desc)

  # (日付補完などの処理...)
  @habits.each do |habit|
    habit.start_date ||= Date.current
    habit.end_date ||= Date.current
  end

  @home_memo = current_user.home_memo || current_user.create_home_memo!
  @latest_goal = current_user.weight_goals.order(created_at: :desc).first
  @latest_body_record = current_user.body_records.order(created_at: :desc).first

  # ★重要：データの準備がすべて終わった「後」にメッセージを作る
  # さらに .reload をつけて最新のDB状態を強制的に読み込ませる
  @message = current_user.reload.buddy_message
end
end
