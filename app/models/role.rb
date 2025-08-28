
class Role < ApplicationRecord
  has_many :survey_branches, dependent: :destroy
end
