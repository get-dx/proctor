require "test_helper"

class BranchAnalyticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
    @branch = survey_branches(:one)
    
    # Create some test responses
    3.times do |i|
      Response.create!(
        survey: @survey,
        question: @question,
        survey_branch: @branch,
        value: "Test response #{i + 1}"
      )
    end
    
    # Soft delete some items for testing
    @survey.responses.limit(1).each(&:destroy)
    @survey.questions.limit(1).each(&:destroy)
  end

  test "should show analytics with active data only" do
    get survey_analytics_path(@survey)
    assert_response :success
    
    # Should show only active data counts
    assert_select "dd", text: /#{@survey.responses.count}/
    assert_select "dd", text: /#{@survey.questions.count}/
    
    # Should not show deleted indicators
    assert_select "span.text-red-500", count: 0
  end
  
  test "should show analytics with deleted data included" do
    get survey_analytics_path(@survey, show_deleted: true)
    assert_response :success
    
    # Should show total data counts including deleted
    total_responses = @survey.responses.with_deleted.count
    total_questions = @survey.questions.with_deleted.count
    
    assert_select "dd", text: /#{total_responses}/
    assert_select "dd", text: /#{total_questions}/
    
    # Should show deleted indicators if there are deleted items
    if @survey.responses.only_deleted.count > 0
      assert_select "span.text-red-500", text: /deleted/
    end
  end
  
  test "should show deletion analytics section when viewing deleted data" do
    get survey_analytics_path(@survey, show_deleted: true)
    assert_response :success
    
    # Should show deletion analytics section
    assert_select "h3", text: "Deletion Analytics"
    assert_select "h4", text: "Recent Deletions"
    assert_select "h4", text: "Deletion Patterns"
  end
  
  test "should not show deletion analytics section when viewing active data only" do
    get survey_analytics_path(@survey)
    assert_response :success
    
    # Should not show deletion analytics section
    assert_select "h3", text: "Deletion Analytics", count: 0
  end
  
  test "analytics tabs should work correctly" do
    get survey_analytics_path(@survey)
    assert_response :success
    
    # Should show "Active Data Only" as active tab
    assert_select "a.border-indigo-500", text: "Active Data Only"
    assert_select "a.border-transparent", text: "Include Deleted Data"
    
    get survey_analytics_path(@survey, show_deleted: true)
    assert_response :success
    
    # Should show "Include Deleted Data" as active tab
    assert_select "a.border-indigo-500", text: "Include Deleted Data"
    assert_select "a.border-transparent", text: "Active Data Only"
  end
  
  test "should handle surveys with no deleted data gracefully" do
    # Create a clean survey with no deleted data
    clean_survey = Survey.create!(title: "Clean Survey", description: "No deleted data")
    Role.find_each do |role|
      SurveyBranch.create!(survey: clean_survey, role: role, name: "#{role.name} Branch")
    end
    
    get survey_analytics_path(clean_survey, show_deleted: true)
    assert_response :success
    
    # Should show zero deleted counts
    assert_select "span.text-red-500", count: 0
  end
  
  test "should calculate response rates correctly with deleted data" do
    get survey_analytics_path(@survey, show_deleted: true)
    assert_response :success
    
    # Response rate should use the correct scope
    total_possible = @survey.survey_branches.with_deleted.joins(:branch_questions).count
    expected_rate = total_possible.zero? ? 0 : (@survey.responses.with_deleted.count.to_f / total_possible * 100).round(2)
    
    assert_select "dd", text: "#{expected_rate}%"
  end
end