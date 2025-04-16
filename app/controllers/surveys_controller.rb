class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :take, :submit, :analytics]

  def index
    @surveys = Survey.all
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
    if params[:role]
      @questions = Role.find(params[:role]).questions.where(survey: @survey).order(:position)
      if @questions.empty?
        redirect_to take_survey_path(@survey), alert: 'No questions found, please select another role.'
      end
    else
      @roles = Role.all
      @questions = []
    end
  end
  
  def submit
    if response_params[:response].present?
      if response_params[:response][:responses].present?
        response_params[:response][:responses].each do |response|
          @survey.responses.create(
            question_id: response[:question_id],
            value: response[:value],
            role_ids: [response_params[:response][:role]]
          )
        end
      end
      redirect_to surveys_path, notice: 'Thank you for completing the survey!'
    else
      redirect_to take_survey_path(@survey), alert: 'Please answer at least one question.'
    end
  end

  def analytics
    @analytics = []
    analytic_struct = Struct.new(:role, :total_questions, :total_responses)

    @question_count = @survey.questions.count
    @response_count = @survey.responses.count

    Role.all.each do |role|
       analytic = analytic_struct.new(
        role.name,
        role.questions.where(survey: @survey).count,
        role.responses.where(survey: @survey).count
      )
      @analytics << analytic 
    end
  end
  
  private
  
  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(:title, :description)
  end

  def response_params
    params.permit!
  end
end
