class Habit < ApplicationRecord
  belongs_to :user

  # 目標日数（例: 2/1〜2/10 → 10日）
  def total_days
    return nil if start_date.blank? || end_date.blank?
    (end_date - start_date).to_i + 1
  end

  # 今日が何日目か
  def current_day
  return nil if start_date.blank?
  [ (Date.current - start_date).to_i + 1, total_days ].min
  end

# 残り日数
def remaining_days
  return nil if end_date.blank?
  (end_date - Date.current).to_i
end
end
