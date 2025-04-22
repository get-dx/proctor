module Questions
  class RoleFilter
    prepend MemoWise

    attr_reader :questions, :target_role_name

    def initialize(questions:, target_role_name:)
      @questions = questions
      @target_role_name = target_role_name
    end

    def target
      roles.find { |role| role.name == target_role_name }
    end

    def others
      all - [target]
    end

    def all
      roles
    end

    private

    def roles
      Role.where(id: role_ids)
    end
    memo_wise :roles

    def role_ids
      return [] if questions.nil?

      questions.pluck(:role_id).compact.uniq
    end
    memo_wise :role_ids
  end
end
