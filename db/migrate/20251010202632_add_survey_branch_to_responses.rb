class AddSurveyBranchToResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :responses, :survey_branch, null: true, foreign_key: true
  end
end