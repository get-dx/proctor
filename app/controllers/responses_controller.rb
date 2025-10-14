class ResponsesController < ApplicationController
  def create
    @survey = Survey.find(params[:survey_id])
    
    responses_created = []
    errors = []
    
    # Create individual response records for each question
    if params[:response][:question_responses_attributes]
      params[:response][:question_responses_attributes].each do |question_response|
        content = question_response[:content]
        
        # Handle array content (for checkbox questions)
        content = content.join(', ') if content.is_a?(Array)
        
        response = Response.new(
          survey_id: params[:response][:survey_id],
          role_id: params[:response][:role_id],
          question_id: question_response[:question_id],
          value: content
        )
        
        if response.save
          responses_created << response
        else
          errors << response.errors.full_messages
        end
      end
    end
    
    respond_to do |format|
      if errors.empty? && responses_created.any?
        format.html { redirect_to surveys_path, notice: 'Response was successfully recorded.' }
        format.json { render json: { success: true }, status: :created }
      else
        # Clean up any created responses if there were errors
        responses_created.each(&:destroy)
        
        error_message = errors.flatten.join(', ')
        error_message = 'There was an error recording your response.' if error_message.blank?
        
        format.html { redirect_to take_survey_path(@survey), alert: error_message }
        format.json { render json: { error: error_message }, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def response_params
    params.require(:response).permit(:survey_id, :role_id, question_responses_attributes: [:question_id, :content])
  end
end
