
require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "associations" do
    assert Response.reflect_on_association(:survey)
    assert Response.reflect_on_association(:question)
  end

  test "value must be present" do
    response = Response.new(survey: Survey.new, question: Question.new, value: nil)
    assert_not response.valid?
    assert_includes response.errors[:value], "can't be blank"

    response.value = "Some answer"
    assert response.valid?
  end

  test "soft delete functionality" do
    survey = Survey.create!(title: "Test Survey")
    question = Question.create!(content: "Test Question", question_type: "text", position: 1)
    response = Response.create!(survey: survey, question: question, value: "Test Answer")
    
    # Test soft delete
    response.destroy
    assert response.deleted?
    assert response.deleted_at.present?
    
    # Test restore
    response.restore
    assert_not response.deleted?
    assert_nil response.deleted_at
  end

  test "default scope excludes soft deleted records" do
    survey = Survey.create!(title: "Test Survey")
    question = Question.create!(content: "Test Question", question_type: "text", position: 1)
    response = Response.create!(survey: survey, question: question, value: "Test Answer for Scoping")
    response_id = response.id
    
    # Response should be visible in default scope
    assert Response.exists?(response_id)
    
    # Soft delete the response
    response.destroy
    
    # Response should not be visible in default scope
    assert_not Response.exists?(response_id)
    
    # But should be visible with with_deleted scope
    assert Response.with_deleted.exists?(response_id)
  end
end
