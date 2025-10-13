require "test_helper"

class BranchQuestionTest < ActiveSupport::TestCase
  test "associations" do
    assert BranchQuestion.reflect_on_association(:survey_branch)
    assert BranchQuestion.reflect_on_association(:question)
  end

  test "soft delete functionality" do
    survey = Survey.create!(title: "Test Survey")
    role = Role.create!(name: "Test Role")
    survey_branch = SurveyBranch.create!(survey: survey, role: role, name: "Test Branch")
    question = Question.create!(content: "Test Question", question_type: "text", position: 1)
    branch_question = BranchQuestion.create!(survey_branch: survey_branch, question: question)
    
    # Test soft delete
    branch_question.destroy
    assert branch_question.deleted?
    assert branch_question.deleted_at.present?
    
    # Test restore
    branch_question.restore
    assert_not branch_question.deleted?
    assert_nil branch_question.deleted_at
  end

  test "default scope excludes soft deleted records" do
    survey = Survey.create!(title: "Test Survey")
    role = Role.create!(name: "Test Role")
    survey_branch = SurveyBranch.create!(survey: survey, role: role, name: "Test Branch")
    question = Question.create!(content: "Test Question", question_type: "text", position: 1)
    branch_question = BranchQuestion.create!(survey_branch: survey_branch, question: question)
    branch_question_id = branch_question.id
    
    # BranchQuestion should be visible in default scope
    assert BranchQuestion.exists?(branch_question_id)
    
    # Soft delete the branch_question
    branch_question.destroy
    
    # BranchQuestion should not be visible in default scope
    assert_not BranchQuestion.exists?(branch_question_id)
    
    # But should be visible with with_deleted scope
    assert BranchQuestion.with_deleted.exists?(branch_question_id)
  end
end
