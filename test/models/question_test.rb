
require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "associations" do
    assert Question.reflect_on_association(:branch_questions)
    assert Question.reflect_on_association(:survey_branches)
    assert Question.reflect_on_association(:responses)
  end
end
