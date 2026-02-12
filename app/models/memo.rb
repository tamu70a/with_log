class Memo < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  validates :memo_date, presence: true

  default_scope { order(memo_date: :desc) }
end
