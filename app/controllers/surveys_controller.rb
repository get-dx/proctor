class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :take, :submit]

  def index
    @surveys = Survey.all
    @roles = Role.all
  end

  def show
    @roles = Role.all
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      # Create a SurveyBranch for each Role
      Role.find_each do |role|
        SurveyBranch.create!(survey: @survey, role: role, name: "#{role.name} Branch")
      end
      respond_to do |format|
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render json: { message: 'Survey created successfully' } }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @survey.update(survey_params)
      respond_to do |format|
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render json: { success: true, redirect_url: survey_path(@survey) }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @survey.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_url, notice: 'Survey was successfully destroyed.'
  end
  
  def take
    @survey = Survey.find(params[:id])
    @role = Role.find(params[:role])
    @branch = @survey.survey_branches.find_by(role: @role)
    @questions = Question.joins(:branch_questions)
                        .where(branch_questions: { survey_branch_id: @branch.id })
                        .order(:position)
  end
  
  def submit
    responses = params[:response][:responses]
    if responses.present? && responses.any?
      responses.each do |response_params|
        @survey.responses.create(
          question_id: response_params[:question_id],
          value: response_params[:content],
        )
      end
      respond_to do |format|
        format.html { redirect_to surveys_path, notice: 'Thank you for completing the survey!' }
        format.json { render json: { message: 'Thank you for completing the survey!' }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to take_survey_path(@survey), alert: 'Please answer at least one question.' }
        format.json { render json: { error: 'Please answer at least one question.' }, status: :unprocessable_entity }
      end
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
