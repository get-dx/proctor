class ResponsesController < ApplicationController
  before_action :set_survey

  def create
    result = process_question_responses(question_response_data)

    respond_to do |format|
      if result[:responses_saved].all?
        format.html { redirect_to surveys_path, notice: "Responses were successfully recorded." }
        format.json { render json: {success: true}, status: :created }
      else
        error_message = result[:errors].flatten.join(", ")
        format.html { redirect_to take_survey_path(@survey), alert: "There was an error recording your responses: #{error_message}" }
        format.json { render json: {error: "Failed to save responses", details: result[:errors].flatten}, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def question_response_data
    response_params[:question_responses_attributes] || []
  end

  def response_params
    params.require(:response).permit(
      :survey_id,
      question_responses_attributes: [:question_id, :content]
    )
  end

  def process_question_responses(question_responses)
    responses_saved = []
    errors = []

    question_responses.each do |question_response|
      response = Response.new(
        survey: @survey,
        question_id: question_response[:question_id],
        value: question_response[:content]
      )

      if response.save
        responses_saved << true
      else
        responses_saved << false
        errors << response.errors.full_messages
      end
    end

    {responses_saved: responses_saved, errors: errors}
  end
end
