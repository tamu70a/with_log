class User < ApplicationRecord
  # Deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :nickname, presence: true

  # アソシエーション
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

  # --- バディのメッセージ生成ロジック ---
  def buddy_message(fetch_ai: true)
    rails_text = generate_rails_status_messages

    ai_message = if fetch_ai
                   OpenaiService.fetch_buddy_message(self)
    else
                   self.buddy_memo || "静かにそばにいますね。"
    end

    # 名前が2回出ないよう、ここで一括して「〇〇さん、」を付与する
    combined_body = [ rails_text, ai_message ].select(&:present?).join(" ")

    "#{nickname}さん、#{combined_body}"
  end

  private

  # Rails側でのメッセージ判定
  def generate_rails_status_messages
    status = weight_status
    incomplete_count = tasks.where(is_done: false).count
    done_habits_count = habits.joins(:habit_checks).where(habit_checks: { check_date: Date.current }).count
    total_habits_count = habits.count

    all_todos_done = tasks.exists? && incomplete_count == 0
    all_habits_done = total_habits_count > 0 && (done_habits_count == total_habits_count)

    messages = []

    # 1. 体重に関するメッセージ（今日入力済みの場合のみ）
    if status && status[:latest_measured_today]
      if status[:goal_achieved]
        messages << "目標体重クリアおめでとうございます！🎉"
      elsif status[:diff_yesterday] && status[:diff_yesterday] < 0
        messages << "昨日より #{status[:diff_yesterday].abs}kg 減ってますよ！"
      else
        messages << "今日も記録、素晴らしいです✨"
      end
    end

    # 2. タスク・習慣に関するメッセージ
    if all_todos_done && all_habits_done
      messages << "TODOも習慣も全部クリア！完璧すぎて眩しいです…！"
    elsif all_habits_done
      messages << "今日の習慣はコンプリートですね！さすがです。"
    elsif done_habits_count > 0
      messages << "習慣を #{done_habits_count} つクリア！着実ですね。"
    end

    messages.join(" ")
  end

  # --- 判定ロジック ---
  def weight_status
    latest = body_records.order(measured_on: :desc).first
    previous = body_records.order(measured_on: :desc).second
    goal = current_goal

    return nil unless latest

    {
      latest_measured_today: latest.measured_on == Date.current,
      latest_weight: latest.weight,
      is_continuous: (latest.measured_on == Date.current && previous&.measured_on == Date.yesterday),
      diff_yesterday: previous ? (latest.weight - previous.weight).round(1) : nil,
      to_goal: goal ? (latest.weight - goal.target_weight).round(1) : nil,
      goal_achieved: goal ? latest.weight <= goal.target_weight : false
    }
  end
end
