class AddUniqueIndexToRolesName < ActiveRecord::Migration[7.0]
  def up
    # First, normalize all existing role names to uppercase
    execute <<-SQL
      UPDATE roles SET name = UPPER(name);
    SQL
    
    # Remove any duplicate roles that may exist after normalization
    # Keep the first occurrence of each name and remove duplicates
    execute <<-SQL
      DELETE FROM roles 
      WHERE id NOT IN (
        SELECT MIN(id) 
        FROM (SELECT id, name FROM roles) AS r 
        GROUP BY name
      );
    SQL
    
    # Add the unique index to prevent future duplicates
    add_index :roles, :name, unique: true
  end
  
  def down
    remove_index :roles, :name
  end
end
