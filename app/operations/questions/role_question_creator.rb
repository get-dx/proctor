module Questions
  class RoleQuestionCreator
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

    def questions
      survey.questions
    end

    def default_role_question_present?
      Questions::DefaultRoleQuestionDetector.new(
        questions: questions
      ).perform
    end
  end
end
