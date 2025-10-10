
class Role < ApplicationRecord
  has_many :survey_branches, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.strip.upcase if name.present?
  end
end
