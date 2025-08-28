
require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  test "associations" do
    assert Response.reflect_on_association(:survey)
    assert Response.reflect_on_association(:question)
  end
end
