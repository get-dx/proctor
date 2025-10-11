require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  test "user can add, edit, and remove questions from a survey" do
    visit surveys_path
    click_on "View", match: :first
    click_on "Add Question"
    fill_in "Question Text", with: "System test question"
    select "text", from: "Question type"
        select "Frontend Engineer", from: "Roles"
    click_on "Create Question"
    assert_text "System test question"
    within("li", text: "System test question") do
      click_on "Edit", match: :first
    end
    fill_in "Question Text", with: "Updated system test question"
    click_on "Update Question"
    assert_text "Question was successfully updated"
    within("li", text: "Updated system test question") do
      accept_confirm do
        click_on "Delete", match: :first
      end
    end
    # Wait for the question to be removed from the DOM
    assert_no_selector "li", text: "Updated system test question", wait: 10
  end
end