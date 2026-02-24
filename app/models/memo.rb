class Memo < ApplicationRecord
  belongs_to :user
  validates :memo_date, presence: true
  validates :content, length: { maximum: 2000 }, presence: true

  default_scope { order(memo_date: :desc, created_at: :desc) }
end
