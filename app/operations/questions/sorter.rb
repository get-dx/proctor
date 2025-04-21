module Questions
  class Sorter

    attr_reader :questions, :target_role_name

    def initialize(questions:, target_role_name: nil)
      @questions = questions
      @target_role_name = target_role_name
    end

    def perform
      return if questions.nil?
      return default_order if target_role_name.nil? || question_role_context.target.nil?

      target_role_order
    end

    def grouped_hidden_questions_by_role_name
      ordered_questions = hidden_questions.order(:position)
      role_names = question_role_context.others.pluck(:id, :name).to_h

      ordered_questions
        .group_by(&:role_id)
        .transform_keys { |role_id| role_names[role_id] }
        .transform_values { |qs| qs.sort_by(&:position) }
    end

    private

    def hidden_questions
      return Question.none if questions.nil?
      other_role_ids = question_role_context.others.pluck(:id)

      questions.where(role_id: other_role_ids)
    end

    def target_role_order
      # any question that doesn't have a role is treated as a question
      # that all roles should answer
      questions.where(role_id: [question_role_context.target.id, nil]).order(:position)
    end

    def default_order
      questions.order(:position)
    end

    def question_role_context
      Questions::RoleFilter.new(
        questions: questions,
        target_role_name: target_role_name
      )
    end
  end
end
