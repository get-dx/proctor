require "test_helper"

class Questions::RoleFilterTest < ActiveSupport::TestCase
  setup do
    Role.destroy_all
    Survey.destroy_all
    Question.destroy_all

    @fe_role = Role.create!(name: "Frontend Engineer")
    @be_role = Role.create!(name: "Backend Engineer")
    @pm_role = Role.create!(name: "Product Manager")

    @survey = Survey.create!(
      title: "Team Survey",
      description: "Employee feedback"
    )

    questions = [
      {
        content: "What best describes your current role?",
        question_type: "checkbox",
        position: 1,
        required: true,
        options: ["Frontend Engineer", "Backend Engineer", "Product Manager"],
        role_id: nil
      },
      {
        content: "What’s the most ridiculous feature request you’ve ever gotten?",
        question_type: "text",
        position: 2,
        required: false,
        role_id: @pm_role.id
      },
      {
        content: "How do you feel about a 12-column layout for mobile?",
        question_type: "text",
        position: 3,
        required: false,
        role_id: @fe_role.id
      },
      {
        content: "What’s the most cursed error message you’ve seen?",
        question_type: "text",
        position: 4,
        required: false,
        role_id: @be_role.id
      },
      {
        content: "What type of restaurant for team dinner?",
        question_type: "multiple_choice",
        position: 5,
        required: false,
        options: ["Mexican", "Indian", "Chinese"],
        role_id: nil
      }
    ]

    questions.each do |question_attrs|
      @survey.questions.create!(question_attrs)
    end

    @questions = @survey.questions
    @role_context = Questions::RoleFilter.new(
      questions: @questions,
      target_role_name: "Frontend Engineer"
    )
  end

  test "target returns the role matching target_role_name" do
    assert_equal @fe_role, @role_context.target
  end

  test "target returns nil if target_role_name does not match any role" do
    role_context = Questions::RoleFilter.new(
      questions: @questions,
      target_role_name: "NonExistent Role"
    )
    assert_nil role_context.target
  end

  test "others returns all roles except the target role" do
    expected_roles = [@be_role, @pm_role]
    assert_equal expected_roles.sort_by(&:id), @role_context.others.sort_by(&:id)
  end

  test "others returns all roles if target is nil" do
    role_context = Questions::RoleFilter.new(
      questions: @questions,
      target_role_name: "NonExistent Role"
    )
    expected_roles = [@fe_role, @be_role, @pm_role]
    assert_equal expected_roles.sort_by(&:id), role_context.others.sort_by(&:id)
  end

  test "all returns all roles associated with questions" do
    expected_roles = [@fe_role, @be_role, @pm_role]
    assert_equal expected_roles.sort_by(&:id), @role_context.all.sort_by(&:id)
  end

  test "all returns empty array if no roles are associated" do
    survey = Survey.create!(title: "No Roles", description: "Test")
    survey.questions.create!(
      content: "General question",
      question_type: "text",
      position: 1,
      required: false,
      role_id: nil
    )
    role_context = Questions::RoleFilter.new(
      questions: survey.questions,
      target_role_name: "Frontend Engineer"
    )
    assert_empty role_context.all
  end
end
