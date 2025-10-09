class BranchAnalyticsController < ApplicationController
  before_action :set_survey

  def show
    @analytics = {
      overview: survey_overview,
      by_branch: branch_response_summary,
      question_analysis: question_breakdown,
      completion_stats: completion_statistics
    }
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def survey_overview
    {
      total_responses: @survey.responses.count,
      total_branches: @survey.survey_branches.count,
      total_questions: @survey.questions.count,
      response_rate: calculate_overall_response_rate
    }
  end

  def branch_response_summary
    @survey.survey_branches.includes(:role, :branch_questions, branch_questions: { question: :responses }).map do |branch|
      # Get responses for questions that belong to this branch
      branch_responses = Response.joins(:question)
                                .joins("JOIN branch_questions ON branch_questions.question_id = questions.id")
                                .where(branch_questions: { survey_branch_id: branch.id })
                                .where(survey_id: @survey.id)
      
      {
        role: branch.role.name,
        branch_id: branch.id,
        total_responses: branch_responses.count,
        unique_respondents: branch_responses.distinct.count('responses.id'),
        questions_count: branch.branch_questions.count,
        avg_response_length: calculate_avg_response_length(branch_responses),
        completion_rate: calculate_branch_completion_rate(branch),
        response_distribution: response_type_distribution(branch)
      }
    end
  end

  def question_breakdown
    @survey.questions.includes(:responses, :branch_questions, branch_questions: :survey_branch).map do |question|
      {
        question_id: question.id,
        content: question.content,
        question_type: question.question_type,
        total_responses: question.responses.where(survey_id: @survey.id).count,
        branches: question.branch_questions.includes(:survey_branch).map do |branch_question|
          branch_responses = question.responses.where(survey_id: @survey.id)
          {
            role: branch_question.survey_branch.role.name,
            response_count: branch_responses.count,
            sample_responses: branch_responses.limit(3).pluck(:value)
          }
        end
      }
    end
  end

  def completion_statistics
    {
      response_timeline: response_timeline_data,
      most_active_branch: most_active_branch,
      least_active_branch: least_active_branch,
      average_responses_per_branch: average_responses_per_branch
    }
  end

  def calculate_overall_response_rate
    total_possible = @survey.survey_branches.joins(:branch_questions).count
    return 0 if total_possible.zero?
    
    (@survey.responses.count.to_f / total_possible * 100).round(2)
  end

  def calculate_avg_response_length(responses)
    text_responses = responses.where.not(value: [nil, ''])
    return 0 if text_responses.empty?
    
    (text_responses.sum { |r| r.value.to_s.length } / text_responses.count.to_f).round(2)
  end

  def calculate_branch_completion_rate(branch)
    total_questions = branch.branch_questions.count
    return 0 if total_questions.zero?
    
    branch_responses = Response.joins(:question)
                              .joins("JOIN branch_questions ON branch_questions.question_id = questions.id")
                              .where(branch_questions: { survey_branch_id: branch.id })
                              .where(survey_id: @survey.id)
    
    (branch_responses.count.to_f / total_questions * 100).round(2)
  end

  def response_type_distribution(branch)
    Response.joins(:question)
           .joins("JOIN branch_questions ON branch_questions.question_id = questions.id")
           .where(branch_questions: { survey_branch_id: branch.id })
           .where(survey_id: @survey.id)
           .group('questions.question_type')
           .count
  end

  def response_timeline_data
    @survey.responses
        .where('created_at >= ?', 30.days.ago)
        .group("DATE(created_at)")
        .order("DATE(created_at)")
        .count
  end

  def most_active_branch
    branch_data = branch_response_summary
    return nil if branch_data.empty?
    
    branch_data.max_by { |b| b[:total_responses] }
  end

  def least_active_branch
    branch_data = branch_response_summary
    return nil if branch_data.empty?
    
    branch_data.min_by { |b| b[:total_responses] }
  end

  def average_responses_per_branch
    branch_data = branch_response_summary
    return 0 if branch_data.empty?
    
    (branch_data.sum { |b| b[:total_responses] } / branch_data.count.to_f).round(2)
  end
end