class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  
  validates :value, presence: true
  
  # This will be used to track which version of the survey (A or B) was shown to the user
  # The candidate will implement the logic to determine this
  attribute :survey_version, :string
end
