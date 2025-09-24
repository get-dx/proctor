
class Role < ApplicationRecord
  has_many :survey_branches, dependent: :destroy

  validates :name, presence: true
end
