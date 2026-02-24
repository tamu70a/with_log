class Child < ApplicationRecord
  belongs_to :user
  has_many :growth_records, dependent: :destroy
  validates :name, presence: { message: "を入力してください" }, length: { maximum: 255 }
  validates :birthday, presence: { message: "を入力してください" }

  # 生年月日から現在の合計月齢を計算する
  def current_month_age
    return 0 unless birthday
    (Date.today.year * 12 + Date.today.month) - (birthday.year * 12 + birthday.month)
  end

  # 月齢に応じた日付範囲を計算する
  def date_range_for(month_age)
    return "" unless birthday
    start_date = birthday + month_age.months
    end_date = start_date + 1.month - 1.day
    "#{start_date.strftime('%-m/%-d')} - #{end_date.strftime('%-m/%-d')}"
  end
end
