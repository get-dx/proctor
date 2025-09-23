
require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
    @role = roles(:one)
  end

  test "should get index as html" do
    get survey_questions_url(@survey)
    assert_response :redirect
    assert_redirected_to survey_path(@survey)
    assert_equal "text/html", @response.media_type
  end

  test "should get index as json" do
    get survey_questions_url(@survey, format: :json)
    assert_response :success
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    assert body.is_a?(Array)
  end

  test "should get new" do
    get new_survey_question_url(@survey)
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { question: { content: 'Test?', question_type: 'text' }, role: @role.name }
    end
    assert_redirected_to survey_path(@survey)
  end

  test "should get edit" do
    get edit_survey_question_url(@survey, @question)
    assert_response :success
  end

  test "should update question" do
    patch survey_question_url(@survey, @question), params: { question: { content: 'Updated?' } }
    assert_redirected_to survey_path(@survey)
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete survey_question_url(@survey, @question)
    end
    assert_redirected_to survey_path(@survey)
  end
end
