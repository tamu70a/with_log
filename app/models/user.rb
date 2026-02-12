class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  # app/models/user.rb
  has_one :home_memo, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :memos, dependent: :destroy
end
