
require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "associations" do
    assert Response.reflect_on_association(:survey)
    assert Response.reflect_on_association(:question)
  end

  test "value must be present" do
    response = Response.new(survey: Survey.new, question: Question.new, value: nil)
    assert_not response.valid?
    assert_includes response.errors[:value], "can't be blank"

    response.value = "Some answer"
    assert response.valid?
  end
end
