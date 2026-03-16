class Task < ApplicationRecord
  belongs_to :user
  attr_accessor :editing

  validates :title,
    presence: { message: "を入力してください" },
    length: { maximum: 255 },
    unless: :editing?

  def editing?
    editing == true
  end
end
