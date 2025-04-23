require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  should belong_to(:survey)
  should belong_to(:question)
  should belong_to(:role).optional
  should validate_presence_of(:value)

  def setup
    @response = Response.new
  end

  test "should belong to survey" do
    assert_respond_to @response, :survey
    assert_instance_of Survey, @response.build_survey
  end

  test "should belong to question" do
    assert_respond_to @response, :question
    assert_instance_of Question, @response.build_question
  end

  test "should belong to role" do
    assert_respond_to @response, :role
    assert_instance_of Role, @response.build_role
  end

  test "role should be optional" do
    @response.survey = surveys(:one)
    @response.question = questions(:one)
    @response.value = "Test value"
    assert @response.valid?
  end

  test "should validate presence of value" do
    @response.survey = surveys(:one)
    @response.question = questions(:one)
    @response.role = roles(:product_manager)
    assert_not @response.valid?
    assert_includes @response.errors[:value], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
