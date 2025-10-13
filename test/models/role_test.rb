require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "associations" do
    assert Role.reflect_on_association(:survey_branches)
  end

  test "soft delete functionality" do
    role = Role.create!(name: "test role")
    
    # Test soft delete
    role.destroy
    assert role.deleted?
    assert role.deleted_at.present?
    
    # Test restore
    role.restore
    assert_not role.deleted?
    assert_nil role.deleted_at
  end

  test "default scope excludes soft deleted records" do
    role = Role.create!(name: "test role for scoping")
    role_id = role.id
    
    # Role should be visible in default scope
    assert Role.exists?(role_id)
    
    # Soft delete the role
    role.destroy
    
    # Role should not be visible in default scope
    assert_not Role.exists?(role_id)
    
    # But should be visible with with_deleted scope
    assert Role.with_deleted.exists?(role_id)
  end

  test "deletion_impact returns correct data" do
    # Create a role with survey branch
    survey = surveys(:one)
    role = Role.create!(name: "role for impact test")
    SurveyBranch.create!(survey: survey, role: role, name: "Impact Test Branch")
    
    impact = role.deletion_impact
    
    assert impact.key?(:survey_branches)
    assert impact.key?(:total_responses)
    assert impact.key?(:total_questions)
    assert impact.key?(:affected_surveys)
    assert impact.key?(:survey_titles)
    
    assert_kind_of Integer, impact[:survey_branches]
    assert_kind_of Integer, impact[:total_responses]
    assert_kind_of Integer, impact[:total_questions]
    assert_kind_of Integer, impact[:affected_surveys]
    assert_kind_of Array, impact[:survey_titles]
    
    assert_equal 1, impact[:survey_branches]
    assert_equal 1, impact[:affected_surveys]
  end

  test "deletion_status returns appropriate message" do
    # Test role with no data
    empty_role = Role.create!(name: "empty role")
    assert_equal "Can be soft deleted safely", empty_role.deletion_status
    
    # Test deleted role
    deleted_role = Role.create!(name: "deleted role")
    deleted_role.destroy
    status = deleted_role.deletion_status
    assert status.include?("Already deleted on")
  end

  test "soft delete preserves data" do
    # Create a role with survey branch
    survey = surveys(:one)
    role = Role.create!(name: "test role with data")
    branch = SurveyBranch.create!(survey: survey, role: role, name: "Test Branch")
    
    branch_id = branch.id
    
    # Soft delete the role
    role.destroy
    
    # Role should be soft deleted but data preserved
    assert role.deleted?
    
    # Survey branch should still exist (not cascaded)
    assert SurveyBranch.exists?(branch_id)
  end

  test "with_deleted scope includes all records" do
    initial_count = Role.count
    initial_with_deleted_count = Role.with_deleted.count
    
    Role.create!(name: "active role")
    deleted_role = Role.create!(name: "deleted role")
    deleted_role.destroy
    
    # Default scope should show initial + 1 active role
    assert_equal initial_count + 1, Role.count
    
    # with_deleted should show initial + 2 (both active and deleted)
    assert_equal initial_with_deleted_count + 2, Role.with_deleted.count
  end

  test "only_deleted scope shows only soft deleted records" do
    Role.create!(name: "active role")
    deleted_role = Role.create!(name: "deleted role")
    deleted_role.destroy
    
    # only_deleted should show only the deleted one
    deleted_roles = Role.only_deleted
    assert deleted_roles.any? { |r| r.id == deleted_role.id }
  end

  test "persisted returns false for soft deleted records" do
    role = Role.create!(name: "test role")
    assert role.persisted?
    
    role.destroy
    assert_not role.persisted?
  end
end
