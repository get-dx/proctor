class AddDeletedAtToAllModels < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :deleted_at, :datetime
    add_column :surveys, :deleted_at, :datetime
    add_column :questions, :deleted_at, :datetime
    add_column :survey_branches, :deleted_at, :datetime
    add_column :responses, :deleted_at, :datetime
    add_column :branch_questions, :deleted_at, :datetime

    add_index :roles, :deleted_at
    add_index :surveys, :deleted_at
    add_index :questions, :deleted_at
    add_index :survey_branches, :deleted_at
    add_index :responses, :deleted_at
    add_index :branch_questions, :deleted_at
  end
end
