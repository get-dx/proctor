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
end
