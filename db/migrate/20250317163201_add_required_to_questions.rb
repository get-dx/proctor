class AddRequiredToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :required, :boolean
  end
end
