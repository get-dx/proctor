require "application_system_test_case"

class SurveysTest < ApplicationSystemTestCase
  test "user can create, edit, and delete a survey" do
    visit surveys_path
    click_on "New Survey"
    fill_in "Title", with: "System Test Survey"
    fill_in "Description", with: "Survey for system test"
    click_on "Create Survey"
    assert_text "System Test Survey"
    within("li", text: "System Test Survey") do
      click_on "Edit"
    end
    fill_in "Title", with: "Updated System Test Survey"
    click_on "Update Survey"
    assert_text "Updated System Test Survey"
    click_on "Back to Surveys"
    within("li", text: "Updated System Test Survey") do
      accept_confirm do
        click_on "Delete"
      end
    end
    assert_no_text "Updated System Test Survey"
  end

  test "user can take a survey" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "Frontend Engineer", from: "role-select"
    assert_text "Question"
    fill_in "Question for FRONTEND ENGINEER", with: "Test answer"
    fill_in "Question for DATA ENGINEER", with: "Test answer"
    click_on "Submit"
    assert_text "Thank you for completing the survey!", wait: 10
  end
end