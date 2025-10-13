
require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  test "associations" do
    assert Survey.reflect_on_association(:survey_branches)
    assert Survey.reflect_on_association(:branch_questions)
    assert Survey.reflect_on_association(:questions)
    assert Survey.reflect_on_association(:responses)
  end

  test "soft delete functionality" do
    survey = Survey.create!(title: "Test Survey", description: "Test Description")
    
    # Test soft delete
    survey.destroy
    assert survey.deleted?
    assert survey.deleted_at.present?
    
    # Test restore
    survey.restore
    assert_not survey.deleted?
    assert_nil survey.deleted_at
  end

  test "default scope excludes soft deleted records" do
    survey = Survey.create!(title: "Test Survey for Scoping", description: "Test Description")
    survey_id = survey.id
    
    # Survey should be visible in default scope
    assert Survey.exists?(survey_id)
    
    # Soft delete the survey
    survey.destroy
    
    # Survey should not be visible in default scope
    assert_not Survey.exists?(survey_id)
    
    # But should be visible with with_deleted scope
    assert Survey.with_deleted.exists?(survey_id)
  end

  test "can find only deleted records" do
    active_survey = Survey.create!(title: "Active Survey", description: "Active Description")
    deleted_survey = Survey.create!(title: "Deleted Survey", description: "Deleted Description")
    deleted_survey.destroy
    
    deleted_surveys = Survey.only_deleted
    assert_includes deleted_surveys, deleted_survey
    assert_not_includes deleted_surveys, active_survey
  end
end
