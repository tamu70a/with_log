class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :nickname, presence: true
  # app/models/user.rb
  has_one :home_memo, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :memos, dependent: :destroy
  has_many :body_records, dependent: :destroy
  has_many :weight_goals, dependent: :destroy
  has_many :children, dependent: :destroy

  def current_goal
    weight_goals.order(created_at: :desc).first
  end

# バディのメッセージを生成するルール

# app/models/user.rb

def buddy_message
  status = weight_status
  incomplete_count = tasks.where(is_done: false).count
  done_habits_count = habits.joins(:habit_checks).where(habit_checks: { check_date: Date.current }).count
  total_habits_count = habits.count

  all_todos_done = tasks.exists? && incomplete_count == 0
  all_habits_done = total_habits_count > 0 && (done_habits_count == total_habits_count)

  # メッセージを貯めるための配列
  messages = []

  # --- 1. 体重セクション ---
  if status
    if status[:goal_achieved]
      messages << "目標体重クリアですよ！🎉"
    elsif status[:is_continuous]
      messages << "昨日も今日も記録したんですね！継続の天才✨"
    elsif status[:diff_yesterday] && status[:diff_yesterday] < 0
      messages << "昨日より #{status[:diff_yesterday].abs}kg 減ってますよ！"
    end
  end

  # --- 2. 習慣・TODOセクション ---
  if all_todos_done && all_habits_done
    messages << "TODOも習慣も全部クリア！完璧すぎて眩しいです…！"
  elsif all_habits_done
    messages << "今日の習慣はコンプリートですね！さすがです。"
  elsif done_habits_count > 0
    messages << "習慣を #{done_habits_count} つクリア！着実ですね。"
  end

  # --- 3. 締めの一言（何も褒めることがない時や、一言添えたい時） ---
  if messages.empty?
    if childcare_mode
      messages << "今日もお疲れ様。無理だけはしないでくださいね。"
    else
      messages << "自分のペースで大丈夫。応援していますよ！"
    end
  end

  # 最後に「 」（スペース）で繋いで一つの文章にする
  # 例：「継続の天才✨ 習慣を 2 つクリア！着実ですね。」
  "#{nickname}さん、" + messages.join(" ")
end
# 判定ロジック
def weight_status
  latest = body_records.order(measured_on: :desc).first
  previous = body_records.order(measured_on: :desc).second
  goal = current_goal

  return nil unless latest

  {
    latest_weight: latest.weight,
    # 最新が今日、かつ、その前が昨日なら「継続」
    is_continuous: (latest.measured_on == Date.current && previous&.measured_on == Date.yesterday),
    diff_yesterday: previous ? (latest.weight - previous.weight).round(1) : nil,
    to_goal: goal ? (latest.weight - goal.target_weight).round(1) : nil,
    goal_achieved: goal ? latest.weight <= goal.target_weight : false
  }
end
end
