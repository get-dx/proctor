class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  has_many :response_role, dependent: :destroy
  has_many :role, through: :response_role, dependent: :destroy
  
  validates :value, presence: true
end
