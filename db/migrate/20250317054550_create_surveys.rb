class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
