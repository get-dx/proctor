class QuestionsController < ApplicationController
  before_action :set_survey
  before_action :set_question, only: [:edit, :update, :destroy]

  def new
    @question = @survey.questions.new
  end

  def create
    @question = @survey.questions.new(question_params)

    if @question.save
      redirect_to survey_path(@survey), notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to survey_path(@survey), notice: 'Question was successfully updated.'
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
    @question = @survey.questions.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:content, :question_type, :position)
  end
end
