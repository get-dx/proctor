require "test_helper"

class Questions::RoleFilterTest < ActiveSupport::TestCase
  setup do
    @survey = Survey.create!(
      title: "Team Survey",
      description: "Employee feedback"
    )
  end

  test "does not create a role question if there are no questions" do
    assert_no_difference -> { Question.count } do
      Questions::RoleQuestionCreator.new(survey: @survey).perform
    end
    questions = @survey.questions
    assert_empty questions
  end

  test "does not create a duplicate role question with same content (case-insensitive)" do
    Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT.upcase,
      question_type: "multiple_choice",
      position: 1,
      required: true,
      options: Role.valid_roles
    )
    assert_no_difference -> { Question.count } do
      Questions::RoleQuestionCreator.new(survey: @survey).perform
    end
  end

  test "does not create a question if similar question exists with different option order" do
    Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT.downcase,
      question_type: "multiple_choice",
      position: 1,
      required: true,
      options: Role.valid_roles.shuffle
    )
    assert_no_difference -> { Question.count } do
      Questions::RoleQuestionCreator.new(survey: @survey).perform
    end
  end

  test "does not create a question if any question has role_id set" do
    Question.create!(
      survey: @survey,
      content: "Regular question",
      question_type: "text",
      position: 2,
      required: true,
      role_id: nil
    )

    Question.create!(
      survey: @survey,
      content: "Test question with role",
      question_type: "text",
      position: 3,
      required: true,
      role_id: Role.last.id
    )

    assert_difference -> { Question.count }, 1 do
      Questions::RoleQuestionCreator.new(survey: @survey).perform
    end
  end

  test "creates a role question when all existing questions have nil role_id" do
    Question.create!(
      survey: @survey,
      content: "Regular question 1",
      question_type: "text",
      position: 2,
      required: true,
      role_id: nil
    )

    Question.create!(
      survey: @survey,
      content: "Regular question 2",
      question_type: "text",
      position: 3,
      required: true,
      role_id: nil
    )

    assert_no_difference -> { Question.count } do
      Questions::RoleQuestionCreator.new(survey: @survey).perform
    end
  end
end
