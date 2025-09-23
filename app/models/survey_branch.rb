
class SurveyBranch < ApplicationRecord
  belongs_to :survey
  belongs_to :role
  has_many :branch_questions, dependent: :destroy
  has_many :questions, through: :branch_questions

  validates :role_id, uniqueness: { scope: :survey_id }
end
