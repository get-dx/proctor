module Questions
  class Sorter

    attr_reader :questions, :target_role

    def initialize(questions:, target_role: nil)
      @questions = questions
      @target_role = target_role
    end

    def perform
      return if questions.nil?
      return default_order if target_role.nil?

      target_role_order
    end

    private

    def target_role_order
    end

    def roles
      Role.find!(role_ids)
    end

    def role_ids
      questions.pluck(:role_id).compact.uniq
    end

    def default_order
      questions.order(:position)
    end
  end
end
