
require "test_helper"

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @role = roles(:one)
    @branch = survey_branches(:one)
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

  test "should get take survey for role" do
    get take_survey_url(@survey, role: @role.name)
    assert_response :success
    assert_select 'form' # Should render questions for the branch
  end
end
