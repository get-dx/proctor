class Question < ApplicationRecord
  belongs_to :survey
  has_many :responses, dependent: :destroy
  
  validates :content, presence: true
  validates :question_type, presence: true
  
  # Define question types
  QUESTION_TYPES = ['text', 'multiple_choice', 'checkbox', 'rating'].freeze
  
  # Ensure position is maintained within a survey
  acts_as_list scope: :survey
end
