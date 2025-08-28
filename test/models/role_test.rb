require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "associations" do
    assert Role.reflect_on_association(:survey_branches)
  end
end
