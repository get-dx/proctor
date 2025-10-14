class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  belongs_to :role, optional: false
  
  validates :value, presence: true
end
