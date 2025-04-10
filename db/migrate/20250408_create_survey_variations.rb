class CreateSurveyVariations < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_variations do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    add_reference :questions, :survey_variation, foreign_key: true
  end
end