class WeightGoal < ApplicationRecord
  belongs_to :user

  validates :target_weight, presence: true, numericality: { greater_than: 0 }
  validates :target_date, presence: true

  scope :latest_first, -> { order(created_at: :desc) }

  def days_remaining
    return 0 if target_date < Date.current
    (target_date - Date.current).to_i
  end

  def achieved?(current_weight)
    current_weight <= target_weight
  end

  def remaining_weight(current_weight)
    (current_weight - target_weight).round(1)
  end
end
