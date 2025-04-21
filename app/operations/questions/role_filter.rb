module Questions
  class RoleFilter
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
      Role.where(id: role_ids)
    end

    private

    def other_role_ids
      target_id = target&.id
      target_id ? roles.ids - [target_id] : roles.ids
    end

    def roles
      Role.where(id: role_ids)
    end

    def role_ids
      return [] if questions.nil?

      questions.pluck(:role_id).compact.uniq
    end
  end
end
