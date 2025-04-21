require "test_helper"

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should create responses" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: "Test response"
          }
        ]
      }
    }
    assert_response :redirect
    assert_redirected_to surveys_url
    assert_equal "Responses were successfully recorded.", flash[:notice]
  end

  test "should create responses via JSON" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: "Test response"
          }
        ]
      }
    }, as: :json
    assert_response :created
    assert_equal({"success" => true}, JSON.parse(response.body))
  end

  test "should create responses via nested route" do
    post survey_responses_url(surveys(:one)), params: {
      response: {
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: "Test response"
          }
        ]
      }
    }
    assert_response :redirect
    assert_redirected_to surveys_url
    assert_equal "Responses were successfully recorded.", flash[:notice]
  end

  test "should create responses via nested route as JSON" do
    post survey_responses_url(surveys(:one)), params: {
      response: {
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: "Test response"
          }
        ]
      }
    }, as: :json
    assert_response :created
    assert_equal({"success" => true}, JSON.parse(response.body))
  end

  test "should handle errors when responses fail to save" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: ""
          }
        ]
      }
    }
    assert_response :redirect
    assert_redirected_to take_survey_path(surveys(:one))
    assert_match(/There was an error recording your responses: Value can't be blank/, flash[:alert])
  end

  test "should handle errors when responses fail to save via JSON" do
    post responses_url, params: {
      survey_id: surveys(:one).id,
      response: {
        survey_id: surveys(:one).id,
        question_responses_attributes: [
          {
            question_id: questions(:one).id,
            content: ""
          }
        ]
      }
    }, as: :json
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    assert_equal "Failed to save responses", response_json["error"]
    assert_includes response_json["details"], "Value can't be blank"
  end
end
