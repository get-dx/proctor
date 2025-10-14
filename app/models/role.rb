class Role < ApplicationRecord
  validates :role, presence: true, uniqueness: true
  has_many :questions
  has_many :responses

  AVAILABLE_ROLES = [
    'Data Engineer',
    'Frontend Engineer', 
    'Backend Engineer',
    'Product Manager',
    'Designer',
    'DevOps Engineer',
    'QA Engineer'
  ].freeze
  
end
