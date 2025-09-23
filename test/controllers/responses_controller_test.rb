
require "test_helper"

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
  end

  test "should create response with html" do
    assert_difference('Response.count') do
      post survey_responses_url(@survey), params: { response: { survey_id: @survey.id, question_id: @question.id, value: 'Test answer' } }
    end
    assert_redirected_to surveys_path
  end

  test "should create response with json" do
    assert_difference('Response.count') do
      post survey_responses_url(@survey, format: :json), params: { response: { survey_id: @survey.id, question_id: @question.id, value: 'Test answer' } }
    end
    assert_response :success
    assert_equal "application/json", @response.media_type
  end 

  test "should not create response with html if invalid" do
    assert_no_difference('Response.count') do
      post survey_responses_url(@survey), params: { response: { survey_id: @survey.id, question_id: @question.id, value: nil } }
    end
    assert_redirected_to take_survey_path(@survey)
    assert_equal "There was an error recording your response.", flash[:alert]
  end

  test "should not create response with json if invalid" do
    assert_no_difference('Response.count') do
      post survey_responses_url(@survey, format: :json), params: { response: { survey_id: @survey.id, question_id: @question.id, value: nil } }
    end
    assert_response :unprocessable_entity
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    assert body["error"].present?
  end
end
