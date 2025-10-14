class Survey < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :responses, dependent: :destroy

  def questions_for_role(role)
    branch = questions.find_by(role: role)
    if branch
      questions.where(role: role).or(questions.where(visible_to_all: true))
    else
      questions.where(visible_to_all: true)
    end
  end
end
