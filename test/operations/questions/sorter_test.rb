require "test_helper"

class Questions::SorterTest < ActiveSupport::TestCase
  setup do
    Role.destroy_all
    Survey.destroy_all
    Question.destroy_all

    @fe_role = Role.create!(name: "Frontend Engineer")
    @be_role = Role.create!(name: "Backend Engineer")
    @pm_role = Role.create!(name: "Product Manager")

    @survey = Survey.create!(
      title: "Cat",
      description: "Coffee"
    )

    questions = [
      {
        content: "What’s the most ridiculous feature request you’ve ever gotten from a stakeholder, and how did you handle it?",
        question_type: "text",
        position: 1,
        required: false,
        role_id: @pm_role.id
      },
      {
        content: "How do you feel when a designer hands you a 12-column layout for a mobile screen?",
        question_type: "text",
        position: 2,
        required: false,
        role_id: @fe_role.id
      },
      {
        content: "What’s the most cursed error message you’ve ever seen in a log file, and how did it haunt you?",
        question_type: "text",
        position: 3,
        required: false,
        role_id: @be_role.id
      },
      {
        content: "If we did a team dinner, what type of restaurant would you want to dine at?",
        question_type: "multiple_choice",
        position: 4,
        required: false,
        options: ["Mexican", "Indian", "Chinese", "Something else"],
        role_id: nil
      },
      {
        content: "What’s your go-to move when a sprint is behind but the client wants a demo tomorrow?",
        question_type: "text",
        position: 5,
        required: false,
        options: ["Show a mockup and call it almost done", "Blame unforeseen technical debt", "Rally the team for an all-nighter with pizza"],
        role_id: @pm_role.id
      }
    ]

    questions.each do |question_attrs|
      @survey.questions.create!(question_attrs)
    end

    Questions::RoleQuestionCreator.new(survey: @survey).perform
    @questions = @survey.questions.reload
  end

  test "perform returns nil if questions are nil" do
    sorter = Questions::Sorter.new(questions: nil, target_role_name: @fe_role.name)
    assert_nil sorter.perform
  end

  test "perform returns questions in default order when target_role_name is nil" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: nil)
    result = sorter.perform
    expected_positions = @questions.order(:position).pluck(:position)
    assert_equal expected_positions, result.pluck(:position)
    assert_equal @questions.count, result.count
  end

  test "perform returns questions for target role and nil role_id, ordered by position" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: @fe_role.name)
    result = sorter.perform
    expected_question_ids = @questions.where(role_id: [@fe_role.id, nil]).order(:position).pluck(:id)
    assert_equal expected_question_ids, result.pluck(:id)
    assert_equal [1, 3, 5], result.pluck(:position)
  end

  test "perform returns questions for another role and nil role_id, ordered by position" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: @pm_role.name)
    result = sorter.perform
    expected_question_ids = @questions.where(role_id: [@pm_role.id, nil]).order(:position).pluck(:id)
    assert_equal expected_question_ids, result.pluck(:id)
    assert_equal [1, 2, 5, 6], result.pluck(:position)
  end

  test "grouped_hidden_questions_by_role_name returns a Hash of questions for roles other than the target role, grouped by role name and ordered by position" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: @fe_role.name)
    result = sorter.grouped_hidden_questions_by_role_name

    hidden_roles = [@be_role, @pm_role]
    hidden_role_names = hidden_roles.map(&:name)

    expected_questions = @questions
      .where(role_id: hidden_roles.map(&:id))
      .order(:position)
      .group_by { |q| hidden_roles.find { |r| r.id == q.role_id }.name }

    assert_equal hidden_role_names.sort, result.keys.sort

    hidden_role_names.each do |role_name|
      expected_names = expected_questions[role_name].pluck(:name)
      result_names = result[role_name].pluck(:name)
      assert_equal expected_names, result_names
    end

    all_result_questions = result.values.flatten.sort_by(&:position)
    assert_equal [2, 4, 6], all_result_questions.pluck(:position)
  end

  test "grouped_hidden_questions_by_role_name returns empty result when no questions exist for other roles" do
    survey = Survey.create!(title: "Test", description: "Test")
    survey.questions.create!(
      content: "Test question",
      question_type: "text",
      position: 1,
      required: false,
      role_id: @fe_role.id
    )
    survey.questions.create!(
      content: "General question",
      question_type: "text",
      position: 2,
      required: false,
      role_id: nil
    )

    sorter = Questions::Sorter.new(questions: survey.questions, target_role_name: @fe_role.name)
    result = sorter.grouped_hidden_questions_by_role_name
    assert_empty result
  end

  test "perform handles non-existent target role by returning default order" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: "NonExistent Role")
    result = sorter.perform
    expected_positions = @questions.order(:position).pluck(:position)
    assert_equal expected_positions, result.pluck(:position)
    assert_equal @questions.count, result.count
  end

  test "perform shows all targeted and nil questions except default role question" do
    sorter = Questions::Sorter.new(questions: @questions, target_role_name: @pm_role.name, hide_first_question: true)
    result = sorter.perform
    expected_question_ids = @questions.where(role_id: [@pm_role.id, nil]).where.not(position: 1).order(:position).pluck(:id)
    assert_equal expected_question_ids, result.pluck(:id)
    assert_equal [2, 5, 6], result.pluck(:position)
  end
end
