class QuestionRole < ApplicationRecord
  belongs_to :question
  belongs_to :role
end
