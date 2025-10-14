class AddRolesToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :role, foreign_key: true
    add_column :questions, :visible_to_all, :boolean
  end
end
