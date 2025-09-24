require "application_system_test_case"

class ResponsesTest < ApplicationSystemTestCase
  test "user can submit a response to a survey" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "FRONTEND ENGINEER", from: "role-select"
    fill_in "Answer", with: "System test response"
    click_on "Submit"
    assert_text "Thank you for completing the survey!"
  end

  test "user sees validation error when submitting incomplete response" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "FRONTEND ENGINEER", from: "role-select"
    click_on "Submit"
    assert_text "Please answer at least one question"
  end
end