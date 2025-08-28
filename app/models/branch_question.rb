
class BranchQuestion < ApplicationRecord
  belongs_to :survey_branch
  belongs_to :question
end