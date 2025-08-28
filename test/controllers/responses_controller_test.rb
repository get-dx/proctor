
require "test_helper"

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
  end

  test "should create response" do
    assert_difference('Response.count') do
      post survey_responses_url(@survey), params: { response: { survey_id: @survey.id, question_id: @question.id, value: 'Test answer' } }
    end
    assert_redirected_to surveys_path
  end
end
