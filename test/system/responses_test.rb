require "application_system_test_case"

class ResponsesTest < ApplicationSystemTestCase
  test "user can submit a response to a survey" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "FRONTEND ENGINEER", from: "role-select"
    
    # Wait for the survey form to load
    assert_selector "form", wait: 5
    assert_selector "input[type='text'], textarea", wait: 5

    all("input[type='text'], textarea").each_with_index do |field, index|
      field.set("Test response #{index + 1}")
    end 
    
    click_on "Submit Response"
    assert_text "Thank you for completing the survey!", wait: 10
  end

  test "user sees validation error when submitting incomplete response" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "FRONTEND ENGINEER", from: "role-select"
    
    # Wait for the survey form to load
    assert_selector "form", wait: 5
    
    # Submit without answering any questions (bypasses client validation if no required questions)
    click_on "Submit Response"
    
    # Should now show the server error message
    assert_text "Please answer at least one question", wait: 10
  end 
end