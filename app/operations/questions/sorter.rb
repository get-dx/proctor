module Questions
  class Sorter

    attr_reader :questions, :target_role_name

    def initialize(questions:, target_role_name: nil)
      @questions = questions
      @target_role_name = target_role_name
    end

    def perform
      return if questions.nil?
      return default_order if target_role.nil?

      target_role_order
    end

    def grouped_hidden_questions_by_role_name
      ordered_questions = hidden_questions.order(:position)
      role_names = roles.pluck(:id, :name).to_h

      ordered_questions
        .group_by(&:role_id)
        .transform_keys { |role_id| role_names[role_id] }
        .transform_values { |qs| qs.sort_by(&:position) }
    end

    private

    def hidden_questions
      questions.where(role_id: other_role_ids)
    end

    def target_role_order
      # any question that doesn't have a role is treated as a question
      # that all roles should answer
      questions.where(role_id: [target_role.id, nil]).order(:position)
    end

    def target_role
      roles.find { |role| role.name == target_role_name }
    end

    def other_role_ids
      roles.ids - [target_role.id]
    end

    def roles
      Role.where(id: role_ids)
    end

    def role_ids
      questions.pluck(:role_id).compact.uniq
    end

    def default_order
      questions.order(:position)
    end
  end
end
