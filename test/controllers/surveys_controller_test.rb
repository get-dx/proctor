require "test_helper"

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
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
    assert_difference -> { Survey.count } do
      post surveys_url, params: {survey: {title: "Taco", description: "Cat"}}
    end
    assert_response :redirect
    assert_redirected_to survey_url(Survey.last)
    assert_equal "Survey was successfully created.", flash[:notice]
  end

  test "should get edit" do
    get edit_survey_url(@survey)
    assert_response :success
  end

  test "should update survey" do
    patch survey_url(@survey), params: {survey: {title: "Updated Title", description: "Updated Description"}}
    assert_redirected_to survey_url(@survey)
    assert_equal "Survey was successfully updated.", flash[:notice]
    @survey.reload
    assert_equal "Updated Title", @survey.title
    assert_equal "Updated Description", @survey.description
  end

  test "should destroy survey" do
    assert_difference -> { Survey.count }, -1 do
      delete survey_url(@survey)
    end
    assert_redirected_to surveys_url
    assert_equal "Survey was successfully destroyed.", flash[:notice]
  end

  test "should get take" do
    get take_survey_url(@survey)
    assert_response :success
  end

  test "should get take_v2" do
    get take_v2_survey_url(@survey), params: {question_response_content: questions(:one).content}
    assert_response :success
  end

  test "should submit survey responses" do
    question = questions(:one)
    assert_difference -> { Response.count }, 1 do
      post submit_survey_url(@survey), params: {
        responses: [
          {question_id: question.id, value: question.content}
        ]
      }
    end

    assert_redirected_to surveys_path
    assert_equal "Thank you for completing the survey!", flash[:notice]
  end
end
