class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.references :survey, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end
  end
end
