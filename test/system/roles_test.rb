require "application_system_test_case"

class RolesTest < ApplicationSystemTestCase
  test "user can create, edit, and soft delete a role" do
    visit roles_path
    click_on "New Role"
    fill_in "Name", with: "System Test Role"
    click_on "Create Role"
    assert_text "System Test Role"
    click_on "Edit", match: :first
    fill_in "Name", with: "Updated System Test Role"
    click_on "Update Role"
    assert_text "Updated System Test Role"
    click_on "Back"
    
    # Test soft delete
    within("li", text: "Updated System Test Role") do
      accept_confirm do
        click_on "Delete", match: :first
      end
    end
    assert_no_text "Updated System Test Role"
    
    # Test that deleted role appears in "All Roles" tab
    click_on "All Roles"
    assert_text "Updated System Test Role"
    assert_text "Deleted"
    
    # Test restore functionality
    within("li", text: "Updated System Test Role") do
      accept_confirm do
        click_on "Restore"
      end
    end
    
    # Switch back to active roles and verify it's restored
    click_on "Active Roles"
    assert_text "Updated System Test Role"
    assert_no_text "Deleted"
  end
end