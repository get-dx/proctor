class Question < ApplicationRecord
  belongs_to :survey
  has_many :responses, dependent: :destroy

  validates :content, presence: true
  validates :question_type, presence: true

  # Define question types
  QUESTION_TYPES = ['text', 'long_text', 'multiple_choice', 'checkbox', 'rating'].freeze

  # Ensure position is maintained within a survey
  acts_as_list scope: :survey

  # Serialize options as an array
  serialize :options, Array

  # Ensure options are present for question types that need them
  validate :validate_options_for_question_type

  # Callback to remove question ID from associated SurveyVariations
  before_destroy :remove_from_survey_variations

  private

  def validate_options_for_question_type
    if ['multiple_choice', 'checkbox'].include?(question_type) && (options.nil? || options.empty?)
      errors.add(:options, "can't be blank for #{question_type} questions")
    end
  end

  def remove_from_survey_variations
    SurveyVariation.where("question_ids @> ARRAY[?]::bigint[]", id).find_each do |variation|
      variation.update(question_ids: variation.question_ids - [id])
    end
  end
end
