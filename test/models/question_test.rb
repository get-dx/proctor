
require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "associations" do
    assert Question.reflect_on_association(:branch_questions)
    assert Question.reflect_on_association(:survey_branches)
    assert Question.reflect_on_association(:responses)
  end

  test "validate options for multiple_choice question type" do
    question = Question.new(content: "Choose one", question_type: "multiple_choice", options: nil)
    assert_not question.valid?
    assert_includes question.errors[:options], "can't be blank for multiple_choice questions"

    question.options = ["A", "B", "C"]
    assert question.valid?
  end
end
