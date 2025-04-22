class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :take, :take_v2, :submit]
  before_action :create_role_default_question, only: [:show, :take]

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
      redirect_to @survey, notice: "Survey was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @survey.update(survey_params)
      redirect_to @survey, notice: "Survey was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: "Survey was successfully destroyed."
  end

  def take_v2
    @questions = Questions::Sorter.new(
      questions: @survey.questions,
      target_role_name: params[:question_response_content],
      hide_first_question: true
    ).perform
    render json: {data: @questions}
  end

  def take
    @questions = Questions::Sorter.new(
      questions: @survey.questions,
      target_role_name: nil,
      show_first_question: default_role_question_present?
    ).perform
  end

  def submit
    if params[:responses].present?
      params[:responses].each do |response_params|
        @survey.responses.create(
          question_id: response_params[:question_id],
          value: response_params[:value]
        )
      end
      redirect_to surveys_path, notice: "Thank you for completing the survey!"
    else
      redirect_to take_survey_path(@survey), alert: "Please answer at least one question."
    end
  end

  private

  def default_role_question_present?
    Questions::DefaultRoleQuestionDetector.new(questions: @survey.questions).perform
  end

  def create_role_default_question
    Questions::RoleQuestionCreator.new(
      survey: @survey
    ).perform
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(:title, :description)
  end
end
