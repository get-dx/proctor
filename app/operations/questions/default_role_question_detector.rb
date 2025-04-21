module Questions
  class DefaultRoleQuestionDetector
    attr_reader :questions

    def initialize(questions:)
      @questions = questions
    end

    def perform
      questions.any? do |question|
        # Ensure we account for all variations of weird casing for this text
        question.content.to_s.downcase.strip == Question::DEFAULT_ROLE_TEXT.downcase.strip &&
          question.question_type == "multiple_choice" &&
          question.position == 1 &&
          question.options.sort == Role.valid_roles.sort
      end
    end
  end
end
