
require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "associations" do
    assert Question.reflect_on_association(:branch_questions)
    assert Question.reflect_on_association(:survey_branches)
    assert Question.reflect_on_association(:responses)
  end

  test "soft delete functionality" do
    question = Question.create!(content: "Test Question", question_type: "text", position: 1)
    
    # Test soft delete
    question.destroy
    assert question.deleted?
    assert question.deleted_at.present?
    
    # Test restore
    question.restore
    assert_not question.deleted?
    assert_nil question.deleted_at
  end

  test "default scope excludes soft deleted records" do
    question = Question.create!(content: "Test Question for Scoping", question_type: "text", position: 1)
    question_id = question.id
    
    # Question should be visible in default scope
    assert Question.exists?(question_id)
    
    # Soft delete the question
    question.destroy
    
    # Question should not be visible in default scope
    assert_not Question.exists?(question_id)
    
    # But should be visible with with_deleted scope
    assert Question.with_deleted.exists?(question_id)
  end

  test "can find only deleted records" do
    active_question = Question.create!(content: "Active Question", question_type: "text", position: 1)
    deleted_question = Question.create!(content: "Deleted Question", question_type: "text", position: 2)
    deleted_question.destroy
    
    deleted_questions = Question.only_deleted
    assert_includes deleted_questions, deleted_question
    assert_not_includes deleted_questions, active_question
  end

  test "validate options for multiple_choice question type" do
    question = Question.new(content: "Choose one", question_type: "multiple_choice", options: nil)
    assert_not question.valid?
    assert_includes question.errors[:options], "can't be blank for multiple_choice questions"

    question.options = ["A", "B", "C"]
    assert question.valid?
  end

  test "can create text question" do
    question = Question.new(
      content: "What is your name?",
      question_type: "text",
      position: 1
    )
    
    assert question.valid?, "Text question should be valid: #{question.errors.full_messages}"
    assert question.save, "Text question should save successfully"
  end

  test "can create long_text question" do
    question = Question.new(
      content: "Please describe your experience:",
      question_type: "long_text",
      position: 1
    )
    
    assert question.valid?, "Long text question should be valid: #{question.errors.full_messages}"
    assert question.save, "Long text question should save successfully"
  end

  test "can create multiple_choice question with options" do
    question = Question.new(
      content: "What is your favorite color?",
      question_type: "multiple_choice",
      options: ["Red", "Blue", "Green", "Yellow"],
      position: 1
    )
    
    assert question.valid?, "Multiple choice question should be valid: #{question.errors.full_messages}"
    assert question.save, "Multiple choice question should save successfully"
    assert_equal ["Red", "Blue", "Green", "Yellow"], question.options
  end

  test "cannot create multiple_choice question without options" do
    question = Question.new(
      content: "What is your favorite color?",
      question_type: "multiple_choice",
      position: 1
    )
    
    assert_not question.valid?, "Multiple choice question without options should be invalid"
    assert_includes question.errors[:options], "can't be blank for multiple_choice questions"
  end

  test "can create checkbox question with options" do
    question = Question.new(
      content: "Which languages do you speak?",
      question_type: "checkbox",
      options: ["English", "Spanish", "French", "German"],
      position: 1
    )
    
    assert question.valid?, "Checkbox question should be valid: #{question.errors.full_messages}"
    assert question.save, "Checkbox question should save successfully"
    assert_equal ["English", "Spanish", "French", "German"], question.options
  end

  test "cannot create checkbox question without options" do
    question = Question.new(
      content: "Which languages do you speak?",
      question_type: "checkbox",
      position: 1
    )
    
    assert_not question.valid?, "Checkbox question without options should be invalid"
    assert_includes question.errors[:options], "can't be blank for checkbox questions"
  end

  test "can create rating question" do
    question = Question.new(
      content: "Rate your experience from 1 to 5:",
      question_type: "rating",
      position: 1
    )
    
    assert question.valid?, "Rating question should be valid: #{question.errors.full_messages}"
    assert question.save, "Rating question should save successfully"
  end

  test "validates question_type is one of allowed types" do
    valid_types = Question::QUESTION_TYPES
    
    valid_types.each do |type|
      question = Question.new(
        content: "Test question",
        question_type: type,
        position: 1
      )
      
      # Add options for types that require them
      if ['multiple_choice', 'checkbox'].include?(type)
        question.options = ["Option 1", "Option 2"]
      end
      
      assert question.valid?, "Question with type '#{type}' should be valid: #{question.errors.full_messages}"
    end
  end

  test "requires content to be present" do
    question = Question.new(
      question_type: "text",
      position: 1
    )
    
    assert_not question.valid?, "Question without content should be invalid"
    assert_includes question.errors[:content], "can't be blank"
  end

  test "requires question_type to be present" do
    question = Question.new(
      content: "Test question",
      position: 1
    )
    
    assert_not question.valid?, "Question without question_type should be invalid"
    assert_includes question.errors[:question_type], "can't be blank"
  end
end
