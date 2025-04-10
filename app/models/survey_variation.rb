class SurveyVariation < ApplicationRecord
  belongs_to :survey
  has_many :questions, dependent: :nullify

  validates :name, presence: true

  # Serialize question_ids as an array
  serialize :question_ids, Array

  # Include question_ids in the JSON response
  def as_json(options = {})
    super(options.merge(only: [:id, :survey_id, :name, :question_ids]))
  end
end