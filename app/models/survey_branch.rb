
class SurveyBranch < ApplicationRecord
  belongs_to :survey
  belongs_to :role
  has_many :branch_questions, dependent: :destroy
  has_many :questions, through: :branch_questions
  has_many :responses, dependent: :destroy

  validates :role_id, uniqueness: { scope: :survey_id }

  # Helper method to get completion statistics
  def completion_stats
    {
      total_responses: responses.count,
      total_questions: branch_questions.count,
      completion_rate: branch_questions.count > 0 ? (responses.count.to_f / branch_questions.count * 100).round(2) : 0
    }
  end
end
