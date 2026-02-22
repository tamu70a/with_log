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
  def buddy_message
  # 「今日」の制限を外して、未完了のタスクが残っているかチェック
  # (まだ終わっていないタスクが一つもなければ all_done)
  incomplete_tasks = tasks.where(is_done: false)

  # タスクが1つ以上あって、かつ未完了が0個なら「全部完了！」
  all_done = tasks.present? && incomplete_tasks.empty?
  if all_done
    "#{nickname}さん、すごいです！今日のTODOが全部終わってますね！そんなに頑張るなんて、感動しちゃいました。今夜はゆっくり自分を甘やかしてくださいね✨"
  elsif childcare_mode
    "#{nickname}さん、今日もお子さんのこと、一生懸命でしたね。本当にお疲れ様。無理だけはしないでくださいね。"
  else
    "#{nickname}さん、自分のペースで大丈夫ですよ。今日はどんな一日でしたか？一歩ずつ進んでいきましょう。"
  end
end
end
