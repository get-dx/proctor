class SurveyVariationsController < ApplicationController
  def index
    survey = Survey.find(params[:survey_id])
    @variations = survey.survey_variations.includes(:questions)
    render json: @variations, status: :ok
  end

  def create
    survey = Survey.find(params[:survey_id])
    variation = survey.survey_variations.create!(variation_params)

    # Associate questions with the new variation
    if question_ids.present?
      Question.where(id: question_ids).update_all(survey_variation_id: variation.id)
    end

    render json: variation, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    variation = SurveyVariation.find(params[:id])
    variation.update!(variation_params)

    # Update associated questions if provided
    if question_ids.present?
      # Clear existing associations for this variation
      Question.where(id: variation.question_ids).update_all(survey_variation_id: nil)

      # Associate the new set of questions
      Question.where(id: question_ids).update_all(survey_variation_id: variation.id)
    end

    render json: variation, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    variation = SurveyVariation.find(params[:id])
    Question.where(id: variation.question_ids).update_all(survey_variation_id: nil)
    variation.destroy
    render json: { message: "Survey variation deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Survey variation not found" }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def variation_params
    params.require(:survey_variation).permit(:name)
  end

  def question_ids
    params.permit(question_ids: [])[:question_ids]
  end
end