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
    @role = Role.find_by(id: params[:role])
    
    if @role.nil?
      redirect_to survey_path(@survey), alert: 'Invalid role specified.'
      return
    end
    
    @branch = @survey.survey_branches.find_by(role: @role)
    
    if @branch.nil?
      redirect_to survey_path(@survey), alert: 'No questions available for this role.'
      return
    end
    
    @questions = Question.joins(:branch_questions)
                        .where(branch_questions: { survey_branch_id: @branch.id })
                        .order(:position)
  end
  
  def submit
    responses_data = params[:response][:responses]
    selected_role_id = params[:response][:role_id] || params[:role_id] # Check both locations
    
    if responses_data.present? && responses_data.any?
      # Find the survey branch for the selected role
      selected_role = Role.find_by(id: selected_role_id)
      survey_branch = @survey.survey_branches.find_by(role: selected_role) if selected_role
      
      responses_data.each do |response_params|
        @survey.responses.create(
          question_id: response_params[:question_id],
          value: response_params[:content],
          survey_branch: survey_branch
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
