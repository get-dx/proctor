class Role < ApplicationRecord
  has_many :question_role, dependent: :destroy
  has_many :questions, through: :question_role, dependent: :destroy
  has_many :response_role, dependent: :destroy
  has_many :responses, through: :response_role, dependent: :destroy
end

