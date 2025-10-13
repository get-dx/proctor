require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  setup do
    @survey = surveys(:one)
  end

  test "user can add, edit, and soft delete questions from a survey" do
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
    
    # Test soft delete
    within("li", text: "Updated system test question") do
      accept_confirm do
        click_on "Delete", match: :first
      end
    end
    # Question should disappear from active view
    assert_no_selector "li", text: "Updated system test question", wait: 10
    
    # Test that deleted question appears in "All Questions" tab
    click_on "All Questions"
    assert_text "Updated system test question"
    assert_text "Deleted"
    
    # Test restore functionality
    within("li", text: "Updated system test question") do
      accept_confirm do
        click_on "Restore"
      end
    end
    
    # Switch back to active questions and verify it's restored
    click_on "Active Questions"
    assert_text "Updated system test question"
    assert_no_text "Deleted"
  end

  test "user can create text question" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "What is your name?"
    select "Text", from: "Question type"
    fill_in "Position", with: "1"
    select "Frontend Engineer", from: "Roles"
    check "Required"
    
    click_on "Create Question"
    
    assert_text "Question was successfully created"
    assert_text "What is your name?"
    
    # Verify the question was created correctly
    question = Question.last
    assert_equal "What is your name?", question.content
    assert_equal "text", question.question_type
    assert_equal 1, question.position
    assert question.required?
  end

  test "user can create long text question" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "Please describe your experience in detail:"
    select "Long text", from: "Question type"
    fill_in "Position", with: "2"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    assert_text "Question was successfully created"
    assert_text "Please describe your experience in detail:"
    
    question = Question.last
    assert_equal "Please describe your experience in detail:", question.content
    assert_equal "long_text", question.question_type
    assert_equal 2, question.position
  end

  test "user can create multiple choice question with options field appearing" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "What is your favorite programming language?"
    select "Multiple choice", from: "Question type"
    
    # Verify options field appears when multiple choice is selected
    assert_selector "textarea[name='question[options]']", visible: true
    
    fill_in "Options (one per line)", with: "JavaScript\nPython\nRuby\nGo"
    fill_in "Position", with: "3"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    assert_text "Question was successfully created"
    assert_text "What is your favorite programming language?"
    
    question = Question.last
    assert_equal "What is your favorite programming language?", question.content
    assert_equal "multiple_choice", question.question_type
    assert_equal ["JavaScript", "Python", "Ruby", "Go"], question.options
    assert_equal 3, question.position
  end

  test "user can create checkbox question with options field appearing" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "Which frameworks have you used?"
    select "Checkbox", from: "Question type"
    
    # Verify options field appears when checkbox is selected
    assert_selector "textarea[name='question[options]']", visible: true
    
    fill_in "Options (one per line)", with: "React\nVue\nAngular\nSvelte"
    fill_in "Position", with: "4"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    assert_text "Question was successfully created"
    assert_text "Which frameworks have you used?"
    
    question = Question.last
    assert_equal "Which frameworks have you used?", question.content
    assert_equal "checkbox", question.question_type
    assert_equal ["React", "Vue", "Angular", "Svelte"], question.options
    assert_equal 4, question.position
  end

  test "user can create rating question" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "Rate your overall satisfaction (1-5):"
    select "Rating", from: "Question type"
    fill_in "Position", with: "5"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    assert_text "Question was successfully created"
    assert_text "Rate your overall satisfaction (1-5):"
    
    question = Question.last
    assert_equal "Rate your overall satisfaction (1-5):", question.content
    assert_equal "rating", question.question_type
    assert_equal 5, question.position
  end

  test "options field visibility toggles correctly based on question type" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    # Initially, when text is selected, options should be hidden
    select "Text", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: false
    
    # When switching to multiple choice, options should appear
    select "Multiple choice", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: true
    
    # When switching to checkbox, options should remain visible
    select "Checkbox", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: true
    
    # When switching to rating, options should be hidden
    select "Rating", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: false
    
    # When switching to long text, options should remain hidden
    select "Long text", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: false
    
    # Switch back to multiple choice to verify it shows again
    select "Multiple choice", from: "Question type"
    assert_selector "textarea[name='question[options]']", visible: true
  end

  test "validation errors prevent creation of multiple choice question without options" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "Choose your favorite color"
    select "Multiple choice", from: "Question type"
    # Intentionally leave options field empty
    fill_in "Position", with: "1"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    # Should show validation error
    assert_text "can't be blank for multiple_choice questions"
    assert_current_path new_survey_question_path(@survey)
  end

  test "validation errors prevent creation of checkbox question without options" do
    visit survey_path(@survey)
    click_on "Add Question"
    
    fill_in "Question Text", with: "Select all that apply"
    select "Checkbox", from: "Question type"
    # Intentionally leave options field empty
    fill_in "Position", with: "1"
    select "Frontend Engineer", from: "Roles"
    
    click_on "Create Question"
    
    # Should show validation error
    assert_text "can't be blank for checkbox questions"
    assert_current_path new_survey_question_path(@survey)
  end

  test "user can create all question types successfully" do
    question_types = [
      { type: "Text", content: "What is your name?", db_type: "text" },
      { type: "Long text", content: "Describe your experience:", db_type: "long_text" },
      { type: "Multiple choice", content: "Choose one:", db_type: "multiple_choice", options: "Option A\nOption B\nOption C" },
      { type: "Checkbox", content: "Select all:", db_type: "checkbox", options: "Choice 1\nChoice 2\nChoice 3" },
      { type: "Rating", content: "Rate this (1-5):", db_type: "rating" }
    ]
    
    question_types.each_with_index do |q_data, index|
      visit survey_path(@survey)
      click_on "Add Question"
      
      fill_in "Question Text", with: q_data[:content]
      select q_data[:type], from: "Question type"
      
      if q_data[:options]
        # Wait for options field to appear and fill it
        assert_selector "textarea[name='question[options]']", visible: true
        fill_in "Options (one per line)", with: q_data[:options]
      end
      
      fill_in "Position", with: (index + 1).to_s
      select "Frontend Engineer", from: "Roles"
      
      click_on "Create Question"
      
      assert_text "Question was successfully created"
      assert_text q_data[:content]
      
      # Verify in database
      question = Question.where(content: q_data[:content]).last
      assert_not_nil question, "Question with content '#{q_data[:content]}' was not created"
      assert_equal q_data[:db_type], question.question_type
      
      if q_data[:options]
        expected_options = q_data[:options].split("\n")
        assert_equal expected_options, question.options
      end
    end
  end
end