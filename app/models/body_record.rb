class BodyRecord < ApplicationRecord
  belongs_to :user

  scope :latest_first, -> { order(measured_on: :desc) }
end
