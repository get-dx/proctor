require "application_system_test_case"

class RolesTest < ApplicationSystemTestCase
  test "user can create, edit, and delete a role" do
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
    # Accept the confirmation alert when clicking Delete
    within("li", text: "Updated System Test Role") do
      accept_confirm do
        click_on "Delete", match: :first
      end
    end
    assert_no_text "Updated System Test Role"
  end
end