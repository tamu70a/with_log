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

  def checked_today?
    habit_checks.exists?(check_date: Date.current)
  end
end
