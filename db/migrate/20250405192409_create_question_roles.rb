class CreateQuestionRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :question_roles do |t|
      t.belongs_to :question
      t.belongs_to :role
      t.timestamps
    end
  end
end
