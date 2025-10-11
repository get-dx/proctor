
class Role < ApplicationRecord
  has_many :survey_branches, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  before_validation :normalize_name

  def display_name
    return nil unless name.present?
    
    # Common acronyms that should stay uppercase
    acronyms = %w[QA UI UX API CEO CTO VP IT HR AI ML]
    
    name.titleize.split.map do |word|
      acronyms.include?(word.upcase) ? word.upcase : word
    end.join(' ')
  end

  private

  def normalize_name
    self.name = name.strip.downcase if name.present?
  end
end
