class Task < ApplicationRecord
  belongs_to :user
  attr_accessor :editing
end
