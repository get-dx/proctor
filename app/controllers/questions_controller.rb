class QuestionsController < ApplicationController
  before_action :set_survey
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_role, only: [:new, :create, :edit, :update, :destroy]

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    process_options

    if @question.save
      branch = @survey.survey_branches.find_by(survey_id: @survey.id, role_id: @role.id)
      BranchQuestion.create!(survey_branch: branch, question: @question)
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
    redirect_to survey_path(@survey), notice: 'Question was successfully destroyed.'
  end
  
  private
  
  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
  
  def set_question
    @question = Question.find(params[:id])
  end

  def set_role
    @role = Role.find_by(name: params[:role].upcase) if params[:role].present?
  end
  
  def question_params
    params.require(:question).permit(:content, :question_type, :position, :required, options: [])
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
