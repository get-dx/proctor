
class Survey < ApplicationRecord
  include SoftDeletable
  
  has_many :survey_branches
  has_many :branch_questions, through: :survey_branches
  has_many :questions, through: :branch_questions
  has_many :responses

  validates :title, presence: true
end
