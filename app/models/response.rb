class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  
  validates :value, presence: true
end
