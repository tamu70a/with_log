class Habit < ApplicationRecord
  has_many :habit_checks, dependent: :destroy

  def current_count
    habit_checks.where("check_date <= ?", Date.current).count
  rescue
    0
  end

  def total_days
    return 0 unless start_date && end_date
    (end_date - start_date).to_i + 1
  end

  def toggle_today_check!
    today_check = habit_checks.find_by(check_date: Date.current)
    if today_check
      today_check.destroy!
    else
      habit_checks.create!(check_date: Date.current)
    end
  end

  # 今日の分が完了しているか
  def checked_today?
    habit_checks.exists?(check_date: Date.current)
  end

  # 現在の継続日数を計算
  def current_streak
    count = 0
    date = Date.current

    # 今日チェックがない場合は、昨日から遡ってカウント
    date = date.yesterday unless checked_today?

    # 遡って連続している間だけカウントを増やす
    while habit_checks.exists?(check_date: date)
      count += 1
      date = date.yesterday
    end
    count
  end
end
