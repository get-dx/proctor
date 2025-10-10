
class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  belongs_to :survey_branch, optional: true

  validates :value, presence: true
end
