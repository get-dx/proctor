
class BranchQuestion < ApplicationRecord
  include SoftDeletable
  
  belongs_to :survey_branch
  belongs_to :question
end