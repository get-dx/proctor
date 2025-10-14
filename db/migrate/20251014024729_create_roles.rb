class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :role, null: false
      t.text :description

      t.timestamps
    end

    add_index :roles, :role, unique: true
  end
end
