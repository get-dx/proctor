require "test_helper"

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_id: questions(:one).id,
        value: "Test response"
      }
    }
    assert_response :redirect
    assert_redirected_to surveys_url
  end

  test "should create response via JSON" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_id: questions(:one).id,
        value: "Test response"
      }
    }, as: :json
    assert_response :created
  end

  test "should create response via nested route" do
    post survey_responses_url(surveys(:one)), params: {
      response: {
        question_id: questions(:one).id,
        value: "Test response"
      }
    }
    assert_response :redirect
    assert_redirected_to surveys_url
  end

  test "should create response via nested route as JSON" do
    post survey_responses_url(surveys(:one)), params: {
      response: {
        question_id: questions(:one).id,
        value: "Test response"
      }
    }, as: :json
    assert_response :created
  end
end
