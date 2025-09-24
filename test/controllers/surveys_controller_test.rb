require "test_helper"

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @role = roles(:one)
    @branch = survey_branches(:one)
    @question = questions(:one)
    @branch_questions = branch_questions(:one)
  end

  test "should get index" do
    get surveys_url
    assert_response :success
  end

  test "should get show" do
    get survey_url(@survey)
    assert_response :success
  end

  test "should get new" do
    get new_survey_url
    assert_response :success
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post surveys_url, params: { survey: { title: 'New Survey', description: 'Test' } }
    end
    assert_redirected_to survey_path(Survey.last)
  end

  test "should not create survey with invalid params" do
    assert_no_difference('Survey.count') do
      post surveys_url, params: { survey: { title: '', description: '' } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_survey_url(@survey)
    assert_response :success
  end

  test "should update survey" do
    patch survey_url(@survey), params: { survey: { title: 'Updated Title', description: 'Updated Description' } }
    assert_redirected_to survey_path(@survey)
    @survey.reload
    assert_equal 'Updated Title', @survey.title
  end

  test "should not update survey with invalid params" do
    patch survey_url(@survey), params: { survey: { title: '', description: '' } }
    assert_response :unprocessable_entity
    @survey.reload
    assert_not_equal '', @survey.title
  end

  test "should destroy survey" do
    assert_difference('Survey.count', -1) do
      delete survey_url(@survey)
    end
    assert_redirected_to surveys_url
  end

  test "should submit survey responses" do
    responses = [
      { question_id: @question.id, content: "Test answer" }
    ]
    assert_difference('Response.count') do
      post submit_survey_url(@survey), params: { response: { responses: responses } }
    end
    assert_redirected_to surveys_path
    follow_redirect!
    assert_match /Thank you for completing the survey!/, response.body
  end

  test "should not submit survey responses if none provided" do
    assert_no_difference('Response.count') do
      post submit_survey_url(@survey), params: { response: { responses: nil } }
    end
    assert_redirected_to take_survey_path(@survey)
  end

  test "should get take survey for role" do
    get take_survey_url(@survey, role: @role)
    assert_response :success
    assert_select 'form'
  end
end
