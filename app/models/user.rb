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

# app/models/user.rb

# app/models/user.rb

def buddy_message
  # DBから最新の数を直接取得
  incomplete_count = tasks.where(is_done: false).count
  done_habits_count = habits.joins(:habit_checks).where(habit_checks: { check_date: Date.current }).count
  total_habits_count = habits.count

  all_todos_done = tasks.exists? && incomplete_count == 0
  all_habits_done = total_habits_count > 0 && (done_habits_count == total_habits_count)

  # 判定ロジック
  if all_todos_done && all_habits_done
    "#{nickname}さん、完璧すぎて眩しいです…！TODOも習慣も全部クリア！今日はもう自分を甘やかして✨"
  elsif all_habits_done
    "今日の習慣はコンプリートですね！さすがです。残りのTODO（あと#{incomplete_count}個）も応援してます！"
  elsif done_habits_count > 0
    "お、習慣を #{done_habits_count} つクリアしましたね！#{nickname}さんの努力、ちゃんと見てますよ。"
  elsif all_todos_done
    "TODO完了、お見事です！あとは習慣のチェックだけ。スッキリ終わらせちゃいましょう！"
  else
    "自分のペースで大丈夫ですよ。今はTODOが#{incomplete_count}個残っていますね。"
  end
end
end
