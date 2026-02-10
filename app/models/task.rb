class Task < ApplicationRecord
  belongs_to :user
  attr_accessor :editing  # 仮想属性
end
