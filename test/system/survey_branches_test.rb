require "application_system_test_case"

class SurveyBranchesTest < ApplicationSystemTestCase
  test "user can select role and see correct questions" do
    visit surveys_path
    click_on "Take Survey", match: :first
    select "Data Engineer", from: "role-select"
    assert_text "Question for DATA ENGINEER"
    refute_text "Question for FRONTEND ENGINEER"
  end
end
