class Survey < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :survey_variations, dependent: :destroy
end
