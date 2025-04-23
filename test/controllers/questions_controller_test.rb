require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_survey_question_url(survey_id: surveys(:one).id)
    assert_response :success
  end

  test "should get create" do
    post survey_questions_url(survey_id: surveys(:one).id), params: {question: {content: "Test question", question_type: "text"}}
    assert_response :redirect
    assert_redirected_to survey_url(surveys(:one))
  end

  test "should get edit" do
    get edit_survey_question_url(survey_id: surveys(:one).id, id: questions(:one).id)
    assert_response :success
  end

  test "should get update" do
    question = questions(:one)
    patch survey_question_url(survey_id: surveys(:one).id, id: questions(:one).id),
      params: {
        question: {
          content: "foo",
          question_type: "long_text",
        }
      }
    assert_response :redirect
    assert_redirected_to survey_url(surveys(:one))
  end

  test "should get destroy" do
    delete survey_question_url(survey_id: surveys(:one).id, id: questions(:one).id)
    assert_response :redirect
    assert_redirected_to survey_url(surveys(:one))
  end
end
