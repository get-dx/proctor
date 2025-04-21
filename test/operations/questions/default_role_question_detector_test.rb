require "test_helper"

class Questions::DefaultRoleQuestionDetectorTest < ActiveSupport::TestCase
  setup do
    @survey = Survey.create!(
      title: "cat",
      description: "cloud"
    )
  end

  test "perform returns true when question matches default role criteria" do
    question = Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT.upcase,
      question_type: "multiple_choice",
      position: 1,
      required: true,
      options: Role.valid_roles
    )

    detector = Questions::DefaultRoleQuestionDetector.new(questions: [question])
    assert detector.perform
  end

  test "perform returns false when question content doesn't match" do
    question = Question.create!(
      survey: @survey,
      content: "foo",
      question_type: "multiple_choice",
      position: 1,
      required: true,
      options: Role.valid_roles
    )

    detector = Questions::DefaultRoleQuestionDetector.new(questions: [question])
    refute detector.perform
  end

  test "perform returns false when question type is not multiple_choice" do
    question = Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT,
      question_type: "text",
      position: 1,
      required: true,
      options: Role.valid_roles
    )

    detector = Questions::DefaultRoleQuestionDetector.new(questions: [question])
    refute detector.perform
  end

  test "perform returns false when position is not 1" do
    question = Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT,
      question_type: "multiple_choice",
      position: 2,
      required: true,
      options: Role.valid_roles
    )

    detector = Questions::DefaultRoleQuestionDetector.new(questions: [question])
    refute detector.perform
  end

  test "perform returns false when options don't match valid roles" do
    question = Question.create!(
      survey: @survey,
      content: Question::DEFAULT_ROLE_TEXT,
      question_type: "multiple_choice",
      position: 1,
      required: true,
      options: ["invalid_option"]
    )

    detector = Questions::DefaultRoleQuestionDetector.new(questions: [question])
    refute detector.perform
  end
end
