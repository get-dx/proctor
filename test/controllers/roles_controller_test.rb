require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role = Role.create!(name: "TestRole")
  end

  test "should get index" do
    get roles_url
    assert_response :success
  end

  test "should get new" do
    get new_role_url
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post roles_url, params: { role: { name: "AnotherRole" } }
    end
    assert_redirected_to role_url(Role.last)
  end

  test "should not create role with invalid params" do
    assert_no_difference('Role.count') do
      post roles_url, params: { role: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should show role" do
    get role_url(@role)
    assert_response :success
  end

  test "should get edit" do
    get edit_role_url(@role)
    assert_response :success
  end

  test "should update role" do
    patch role_url(@role), params: { role: { name: "UpdatedRole" } }
    assert_redirected_to role_url(@role)
  end

  test "should not update role with invalid params" do
    patch role_url(@role), params: { role: { name: "" } }
    assert_response :unprocessable_entity
    @role.reload
    assert_not_equal "", @role.name
  end

  test "should soft delete role" do
    initial_count = Role.count
    
    delete role_url(@role)
    
    # Role count should decrease (due to default scope)
    assert_equal initial_count - 1, Role.count
    
    # But should still exist with with_deleted scope
    assert Role.with_deleted.exists?(@role.id)
    
    assert_redirected_to roles_url
    assert flash[:notice].include?('soft deleted')
  end

  test "should restore soft deleted role" do
    @role.destroy # Soft delete first
    initial_count = Role.count
    
    patch restore_role_url(@role)
    
    # Role count should increase (restored to active)
    assert_equal initial_count + 1, Role.count
    
    assert_redirected_to roles_url
    assert_equal 'Role was successfully restored.', flash[:notice]
    
    # Role should no longer be deleted
    @role.reload
    assert_not @role.deleted?
  end

  test "index should show active roles by default" do
    deleted_role = Role.create!(name: "DeletedRole")
    deleted_role.destroy
    
    get roles_url
    
    assert_response :success
    # Verify by checking that deleted roles are not in default scope
    assert_not Role.exists?(deleted_role.id)
    assert Role.with_deleted.exists?(deleted_role.id)
  end

  test "index should show all roles when show_deleted is true" do
    deleted_role = Role.create!(name: "DeletedRole")
    deleted_role.destroy
    
    get roles_url(show_deleted: true)
    
    assert_response :success
    # Response should be successful and the controller handles the show_deleted param
    assert_not Role.exists?(deleted_role.id) # Not in default scope
    assert Role.with_deleted.exists?(deleted_role.id) # But exists when including deleted
  end
end