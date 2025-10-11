class QuestionsController < ApplicationController
  before_action :set_survey
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_role, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_roles, only: [:new, :create, :edit, :update]

  def index
    @questions = @survey.questions.distinct

    if params[:survey_branch_id].present?
      @questions = @questions.joins(:branch_questions)
                            .where(branch_questions: { survey_branch_id: params[:survey_branch_id] })
                            .distinct
    elsif params[:role_id].present?
      @questions = @questions.joins(branch_questions: { survey_branch: :role })
                            .where(roles: { id: params[:role_id] })
                            .distinct
    end

    @questions = @questions.order(:position) if @questions.column_names.include?("position")

    respond_to do |format|
      format.json do
        render json: @questions.as_json(
          only: [:id, :content, :question_type, :required]
        )
      end
      format.html { redirect_to survey_path(@survey) }
    end
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params.except(:survey_branch_id))
    process_options

    if @question.save
      branch = @survey.survey_branches.find_by(id: params[:question][:survey_branch_id])
      BranchQuestion.create!(survey_branch: branch, question: @question) if branch
      redirect_to survey_path(@survey), notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      process_options
      if @question.save
        redirect_to survey_path(@survey), notice: 'Question was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to survey_path(@survey), notice: 'Question was successfully destroyed.' }
    end
  end
  
  private
  
  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
  
  def set_question
    @question = @survey.questions.find(params[:id])
  end

  def set_role
    @role = Role.find_by(name: params[:role].downcase) if params[:role].present?
  end

  def set_roles
    @roles = Role.all
  end
  
  def question_params
    params.require(:question).permit(:content, :question_type, :position, :required, options: [], survey_branch_ids: [])
  end
  
  def process_options
    if params[:question][:options].present? && ['multiple_choice', 'checkbox'].include?(@question.question_type)
      # Split the options by newline and remove any blank lines
      @question.options = params[:question][:options].split("\n").map(&:strip).reject(&:blank?)
    else
      @question.options = []
    end
  end
end
