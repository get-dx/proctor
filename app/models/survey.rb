
class Survey < ApplicationRecord
  has_many :survey_branches, dependent: :destroy
  has_many :branch_questions, through: :survey_branches
  has_many :questions, through: :branch_questions
  has_many :responses, dependent: :destroy
end
