class BranchAnalyticsController < ApplicationController
  before_action :set_survey

  def show
    @analytics = {
      overview: survey_overview,
      by_branch: branch_response_summary,
      question_analysis: question_breakdown,
      completion_stats: completion_statistics,
      charts: chart_data
    }
    @chart_data_json = chart_data.to_json
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
    survey_branches_with_associations.map do |branch|
      branch_responses = responses_for_branch(branch)
      
      {
        role: branch.role.name,
        branch_id: branch.id,
        total_responses: branch_responses.count,
        unique_respondents: branch_responses.distinct.count,
        questions_count: branch.branch_questions.count,
        avg_response_length: calculate_avg_response_length(branch_responses),
        completion_rate: calculate_branch_completion_rate(branch),
        response_distribution: response_type_distribution(branch)
      }
    end
  end

  def question_breakdown
    @survey.questions.includes(:responses, :branch_questions).map do |question|
      {
        question_id: question.id,
        content: question.content,
        question_type: question.question_type,
        total_responses: question.responses.where(survey_id: @survey.id).count,
        branches: @survey.survey_branches.includes(:role).map do |branch|
          branch_responses = question.responses.where(survey_id: @survey.id, survey_branch: branch)
          {
            role: branch.role.name,
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
    
    branch_responses = responses_for_branch(branch)
    
    (branch_responses.count.to_f / total_questions * 100).round(2)
  end

  def response_type_distribution(branch)
    responses_for_branch(branch)
      .joins(:question)
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

  def chart_data
    {
      responses_by_branch: responses_by_branch_chart,
      completion_rates: completion_rates_chart,
      response_timeline: response_timeline_chart,
      question_types: question_types_chart,
      daily_responses: daily_responses_chart
    }
  end

  def responses_by_branch_chart
    survey_branches_with_associations.map do |branch|
      [branch.role.name, responses_for_branch(branch).count]
    end.to_h
  end

  def completion_rates_chart
    survey_branches_with_associations.map do |branch|
      completion_rate = calculate_branch_completion_rate(branch).round(1)
      [branch.role.name, completion_rate]
    end.to_h
  end

  def response_timeline_chart
    responses_by_date_range(14)
  end

  def question_types_chart
    @survey.questions.group(:question_type).count.transform_keys(&:humanize)
  end

  def daily_responses_chart
    responses_by_date_range(7)
  end

  # Helper methods for DRY code
  def survey_branches_with_associations
    @survey_branches_with_associations ||= @survey.survey_branches.includes(:role, :branch_questions)
  end

  def responses_for_branch(branch)
    @survey.responses.where(survey_branch: branch)
  end

  def responses_by_date_range(days)
    end_date = Date.current
    start_date = end_date - (days - 1).days
    
    # Get responses within date range
    responses_in_range = @survey.responses.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    
    # Group by date and count
    grouped_responses = responses_in_range.group("DATE(created_at)").count
    
    # Fill in missing dates with 0 count
    result = {}
    (start_date..end_date).each do |date|
      date_key = date.strftime("%Y-%m-%d")
      result[date_key] = grouped_responses[date] || 0
    end
    
    result
  end
end