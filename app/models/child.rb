class Child < ApplicationRecord
  belongs_to :user
  has_many :growth_records, dependent: :destroy

  # 生年月日から現在の合計月齢を計算する
  def current_month_age
    return 0 unless birthday
    (Date.today.year * 12 + Date.today.month) - (birthday.year * 12 + birthday.month)
  end
end
