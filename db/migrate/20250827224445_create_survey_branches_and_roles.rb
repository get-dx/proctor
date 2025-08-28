class CreateSurveyBranchesAndRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, unique: true
      t.timestamps
    end

    create_table :survey_branches do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    create_table :branch_questions do |t|
      t.references :survey_branch, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
