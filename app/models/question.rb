
class Question < ApplicationRecord
  has_many :branch_questions, dependent: :destroy
  has_many :survey_branches, through: :branch_questions
  has_many :responses, dependent: :destroy

  validates :content, presence: true
  validates :question_type, presence: true

  # Define question types
  QUESTION_TYPES = ['text', 'long_text', 'multiple_choice', 'checkbox', 'rating'].freeze

  # Serialize options as an array
  serialize :options, Array

  # Ensure options are present for question types that need them
  validate :validate_options_for_question_type

  private

  def validate_options_for_question_type
    if ['multiple_choice', 'checkbox'].include?(question_type) && (options.nil? || options.empty?)
      errors.add(:options, "can't be blank for #{question_type} questions")
    end
  end
end
