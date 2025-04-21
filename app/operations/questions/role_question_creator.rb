module Questions
  class RoleQuestionCreator
    attr_reader :survey

    def initialize(survey:)
      @survey = survey
    end

    def perform
      return unless questions.present?
      return if no_role_questions?
      return if similar_question_present?

      Question.create!(
        survey: survey,
        content: Question::DEFAULT_ROLE_TEXT,
        question_type: "multiple_choice",
        position: 1,
        required: true,
        options: role_options,
        role_id: nil
      )
    end

    private

    def similar_question_present?
      questions.any? do |question|
        # Ensure we account for all variations of weird casing for this text
        question.content.to_s.downcase.strip == Question::DEFAULT_ROLE_TEXT.downcase.strip &&
        question.question_type == "multiple_choice" &&
        question.position == 1 &&
        question.options.sort == role_options.sort
      end
    end

    def role_options
      Role.valid_roles
    end

    def no_role_questions?
      questions.all? {|question| question.role_id.nil?}
    end

    def questions
      survey.questions
    end
  end
end
