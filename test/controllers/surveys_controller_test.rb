require "test_helper"

class SurveysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get surveys_url
    assert_response :success
  end

  test "should get show" do
    get survey_url(surveys(:one))
    assert_response :success
  end

  test "should get new" do
    get new_survey_url
    assert_response :success
  end

  test "should get create" do
    post surveys_url, params: { survey: { title: "Taco", description: "Cat" } }
    assert_response :redirect
    assert_redirected_to survey_url(Survey.last)
  end
end
