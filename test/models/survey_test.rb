
require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  test "associations" do
    assert Survey.reflect_on_association(:survey_branches)
    assert Survey.reflect_on_association(:branch_questions)
    assert Survey.reflect_on_association(:questions)
    assert Survey.reflect_on_association(:responses)
  end
end
