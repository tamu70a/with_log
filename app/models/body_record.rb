class BodyRecord < ApplicationRecord
  belongs_to :user

  scope :latest_first, -> { order(measured_on: :desc) }

# 体重は必須、かつ0より大きい数字のみ許可
validates :weight, presence: { message: "を入力してください" },
                     numericality: { greater_than: 0, message: "は0より大きい値にしてください" }
end
