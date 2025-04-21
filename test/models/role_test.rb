require "test_helper"

class RoleTest < ActiveSupport::TestCase
  def setup
    Role.destroy_all
  end

  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  test ".valid_roles returns an array of all role names" do
    Role.create!(name: "Engineer")
    Role.create!(name: "Designer")

    result = Role.valid_roles
    assert_equal 2, result.size
    assert_includes result, "Engineer"
    assert_includes result, "Designer"
  end
end
