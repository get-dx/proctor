
class Role < ApplicationRecord
  include SoftDeletable
  
  has_many :survey_branches

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

  # Check what data would be affected by deletion
  def deletion_impact
    branches = survey_branches.includes(:responses, :branch_questions)
    total_responses = branches.sum { |branch| branch.responses.count }
    total_questions = branches.sum { |branch| branch.branch_questions.count }
    affected_surveys = branches.map(&:survey).uniq
    
    {
      survey_branches: branches.count,
      total_responses: total_responses,
      total_questions: total_questions,
      affected_surveys: affected_surveys.count,
      survey_titles: affected_surveys.map(&:title)
    }
  end

  # Get human-readable deletion status
  def deletion_status
    return "Can be soft deleted safely" unless deleted?
    "Already deleted on #{deleted_at.strftime('%B %d, %Y at %I:%M %p')}"
  end

  private

  def normalize_name
    self.name = name.strip.downcase if name.present?
  end
end
