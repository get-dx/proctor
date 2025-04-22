module Questions
  class RoleQuestionCreator
    prepend MemoWise

    attr_reader :survey

    def initialize(survey:)
      @survey = survey
    end

    def perform
      return unless questions.present?
      return if no_role_questions?
      return if default_role_question_present?

      Question.create!(
        survey: survey,
        content: Question::DEFAULT_ROLE_TEXT,
        question_type: "multiple_choice",
        position: 1,
        required: true,
        options: Role.valid_roles,
        role_id: nil
      )
    end

    private

    def no_role_questions?
      questions.all? { |question| question.role_id.nil? }
    end
    memo_wise :no_role_questions?

    def questions
      survey.questions
    end
    memo_wise :questions

    def default_role_question_present?
      Questions::DefaultRoleQuestionDetector.new(
        questions: questions
      ).perform
    end
    memo_wise :default_role_question_present?
  end
end
