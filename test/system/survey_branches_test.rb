require "application_system_test_case"

class SurveyBranchesTest < ApplicationSystemTestCase
  test "user can select role and see correct questions" do
    visit surveys_path
    click_on "Take Survey"
    select "Data Engineer", from: "Role"
    assert_text "Question for Data Engineer"
    refute_text "Question for Frontend Engineer"
  end
end
