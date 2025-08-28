class RemoveSurveyIdFromQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :survey_id, :bigint
  end
end
