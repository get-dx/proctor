require "test_helper"

class SurveyBranchTest < ActiveSupport::TestCase
  test "associations" do
    assert SurveyBranch.reflect_on_association(:survey)
    assert SurveyBranch.reflect_on_association(:role)
    assert SurveyBranch.reflect_on_association(:branch_questions)
    assert SurveyBranch.reflect_on_association(:questions)
  end
end
