class AddRolesToResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :responses, :role, foreign_key: true
  end
end
