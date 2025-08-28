require "test_helper"

class BranchQuestionTest < ActiveSupport::TestCase
  test "associations" do
    assert BranchQuestion.reflect_on_association(:survey_branch)
    assert BranchQuestion.reflect_on_association(:question)
  end
end
