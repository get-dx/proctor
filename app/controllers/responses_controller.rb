class ResponsesController < ApplicationController
  def create
    @survey = Survey.find(params[:survey_id])
    @response = Response.new(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to surveys_path, notice: 'Response was successfully recorded.' }
        format.json { render json: { success: true }, status: :created }
      else
        format.html { redirect_to take_survey_path(@survey), alert: 'There was an error recording your response.' }
        format.json { render json: { error: @response.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def response_params
    params.require(:response).permit(:survey_id, :question_id, :value)
  end
end
