require "test_helper"

class SurveyBranchTest < ActiveSupport::TestCase
  test "associations" do
    assert SurveyBranch.reflect_on_association(:survey)
    assert SurveyBranch.reflect_on_association(:role)
    assert SurveyBranch.reflect_on_association(:branch_questions)
    assert SurveyBranch.reflect_on_association(:questions)
  end

  test "role_id must be unique per survey" do
    survey = Survey.create!(title: "Test Survey")
    role = Role.create!(name: "Test Role")
    SurveyBranch.create!(survey: survey, role: role, name: "Test Branch")
    duplicate = SurveyBranch.new(survey: survey, role: role, name: "Duplicate Branch")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:role_id], "has already been taken"
  end

  test "soft delete functionality" do
    survey = Survey.create!(title: "Test Survey")
    role = Role.create!(name: "Test Role")
    survey_branch = SurveyBranch.create!(survey: survey, role: role, name: "Test Branch")
    
    # Test soft delete
    survey_branch.destroy
    assert survey_branch.deleted?
    assert survey_branch.deleted_at.present?
    
    # Test restore
    survey_branch.restore
    assert_not survey_branch.deleted?
    assert_nil survey_branch.deleted_at
  end

  test "default scope excludes soft deleted records" do
    survey = Survey.create!(title: "Test Survey")
    role = Role.create!(name: "Test Role")
    survey_branch = SurveyBranch.create!(survey: survey, role: role, name: "Test Branch for Scoping")
    survey_branch_id = survey_branch.id
    
    # SurveyBranch should be visible in default scope
    assert SurveyBranch.exists?(survey_branch_id)
    
    # Soft delete the survey_branch
    survey_branch.destroy
    
    # SurveyBranch should not be visible in default scope
    assert_not SurveyBranch.exists?(survey_branch_id)
    
    # But should be visible with with_deleted scope
    assert SurveyBranch.with_deleted.exists?(survey_branch_id)
  end
end
