class CreateResponseRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :response_roles do |t|
      t.belongs_to :response
      t.belongs_to :role
      t.timestamps
    end
  end
end
