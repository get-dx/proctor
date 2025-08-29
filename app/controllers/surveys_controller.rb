class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :take, :submit]

  def index
    @surveys = Survey.all
    @roles = Role.all
  end

  def show
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      redirect_to @survey, notice: 'Survey was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @survey.update(survey_params)
      redirect_to @survey, notice: 'Survey was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: 'Survey was successfully destroyed.'
  end
  
  def take
    @survey = Survey.find(params[:id])
    @role = Role.find_by(name: params[:role].upcase)
    @branch = @survey.survey_branches.find_by(role: @role)
    @questions = Question.joins(:branch_questions)
                        .where(branch_questions: { survey_branch_id: @branch.id })
                        .order(:position)
  end
  
  def submit
    if params[:responses].present?
      params[:responses].each do |response_params|
        @survey.responses.create(
          question_id: response_params[:question_id],
          value: response_params[:value],
        )
      end
      redirect_to surveys_path, notice: 'Thank you for completing the survey!'
    else
      redirect_to take_survey_path(@survey), alert: 'Please answer at least one question.'
    end
  end
  
  private
  
  def set_survey
    @survey = Survey.find(params[:id])
  end
  
  def survey_params
    params.require(:survey).permit(:title, :description)
  end
end
