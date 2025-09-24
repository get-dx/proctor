require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  test "user can add, edit, and remove questions from a survey" do
    visit surveys_path
    click_on "Edit", match: :first
    click_on "Add Question"
    fill_in "Content", with: "System test question"
    select "Text", from: "Question type"
    select "FRONTEND ENGINEER", from: "Roles"
    click_on "Create Question"
    assert_text "System test question"
    click_on "Edit", match: :first
    fill_in "Content", with: "Updated system test question"
    click_on "Update Question"
    assert_text "Updated system test question"
    click_on "Delete", match: :first
    assert_no_text "Updated system test question"
  end
end