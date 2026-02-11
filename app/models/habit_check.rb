# app/models/habit_check.rb
class HabitCheck < ApplicationRecord
  belongs_to :habit

  validates :check_date, uniqueness: { scope: :habit_id } # 同じ日に複数チェック不可
end
