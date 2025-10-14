class AnalyticsController < ApplicationController
  before_action :set_survey
  
  def survey_analytics
    @questions = @survey.questions.includes(:role)
    @responses = @survey.responses.includes(:question, :role)
    @roles = Role.all
    
    # Group responses by question and then by role
    @responses_by_question = @responses.group_by(&:question_id)
    @responses_by_question_and_role = {}
    @responses_by_question.each do |question_id, responses|
      @responses_by_question_and_role[question_id] = responses.group_by(&:role_id)
    end
  end

  private
  
  def set_survey
    @survey = Survey.find(params[:id])
  end
end