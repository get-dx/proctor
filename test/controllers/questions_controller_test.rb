
require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
    @question = questions(:one)
    @role = roles(:one)
  end

  test "should get index as html" do
    get survey_questions_url(@survey)
    assert_response :redirect
    assert_redirected_to survey_path(@survey)
    assert_equal "text/html", @response.media_type
  end

  test "should get index as json" do
    get survey_questions_url(@survey, format: :json)
    assert_response :success
    assert_equal "application/json", @response.media_type
    body = JSON.parse(@response.body)
    assert body.is_a?(Array)
  end

  test "should get new" do
    get new_survey_question_url(@survey)
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { question: { content: 'Test?', question_type: 'text' }, role: @role.name }
    end
    assert_redirected_to survey_path(@survey)
  end

  test "should create text question via controller" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'What is your name?', 
          question_type: 'text',
          position: 1,
          required: true
        }, 
        role: @role.name 
      }
    end
    
    question = Question.last
    assert_equal 'What is your name?', question.content
    assert_equal 'text', question.question_type
    assert_equal 1, question.position
    assert question.required?
    assert_redirected_to survey_path(@survey)
  end

  test "should create long_text question via controller" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'Please describe your experience:', 
          question_type: 'long_text',
          position: 2
        }, 
        role: @role.name 
      }
    end
    
    question = Question.last
    assert_equal 'Please describe your experience:', question.content
    assert_equal 'long_text', question.question_type
    assert_redirected_to survey_path(@survey)
  end

  test "should create multiple_choice question via controller" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'What is your favorite color?', 
          question_type: 'multiple_choice',
          options: "Red\nBlue\nGreen\nYellow",
          position: 3
        }, 
        role: @role.name 
      }
    end
    
    question = Question.last
    assert_equal 'What is your favorite color?', question.content
    assert_equal 'multiple_choice', question.question_type
    assert_equal ['Red', 'Blue', 'Green', 'Yellow'], question.options
    assert_redirected_to survey_path(@survey)
  end

  test "should create checkbox question via controller" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'Which languages do you speak?', 
          question_type: 'checkbox',
          options: "English\nSpanish\nFrench\nGerman",
          position: 4
        }, 
        role: @role.name 
      }
    end
    
    question = Question.last
    assert_equal 'Which languages do you speak?', question.content
    assert_equal 'checkbox', question.question_type
    assert_equal ['English', 'Spanish', 'French', 'German'], question.options
    assert_redirected_to survey_path(@survey)
  end

  test "should create rating question via controller" do
    assert_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'Rate your experience from 1 to 5:', 
          question_type: 'rating',
          position: 5
        }, 
        role: @role.name 
      }
    end
    
    question = Question.last
    assert_equal 'Rate your experience from 1 to 5:', question.content
    assert_equal 'rating', question.question_type
    assert_redirected_to survey_path(@survey)
  end

  test "should not create multiple_choice question without options" do
    assert_no_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'What is your favorite color?', 
          question_type: 'multiple_choice',
          position: 1
        }, 
        role: @role.name 
      }
    end
    
    assert_response :unprocessable_entity
  end

  test "should not create checkbox question without options" do
    assert_no_difference('Question.count') do
      post survey_questions_url(@survey), params: { 
        question: { 
          content: 'Which languages do you speak?', 
          question_type: 'checkbox',
          position: 1
        }, 
        role: @role.name 
      }
    end
    
    assert_response :unprocessable_entity
  end

  test "should create all question types successfully" do
    Question::QUESTION_TYPES.each_with_index do |question_type, index|
      params = {
        question: {
          content: "Test #{question_type} question?",
          question_type: question_type,
          position: index + 1
        },
        role: @role.name
      }
      
      # Add options for types that require them
      if ['multiple_choice', 'checkbox'].include?(question_type)
        params[:question][:options] = "Option 1\nOption 2\nOption 3"
      end
      
      assert_difference('Question.count') do
        post survey_questions_url(@survey), params: params
      end
      
      assert_redirected_to survey_path(@survey), "Failed to create #{question_type} question"
      
      question = Question.last
      assert_equal question_type, question.question_type, "Question type not set correctly for #{question_type}"
      
      if ['multiple_choice', 'checkbox'].include?(question_type)
        assert_equal ['Option 1', 'Option 2', 'Option 3'], question.options, "Options not set correctly for #{question_type}"
      end
    end
  end

  test "should get edit" do
    get edit_survey_question_url(@survey, @question)
    assert_response :success
  end

  test "should update question" do
    patch survey_question_url(@survey, @question), params: { question: { content: 'Updated?' } }
    assert_redirected_to survey_path(@survey)
  end

  test "should soft delete question" do
    # Should not change total count (including deleted)
    assert_no_difference('Question.with_deleted.count') do
      # But should decrease active count
      assert_difference('Question.count', -1) do
        delete survey_question_url(@survey, @question)
      end
    end
    
    @question.reload
    assert @question.deleted?
    assert_redirected_to survey_path(@survey)
  end
  
  test "should restore question" do
    # First soft delete the question
    @question.destroy
    assert @question.deleted?
    
    # Then restore it
    assert_difference('Question.count', 1) do
      patch restore_survey_question_url(@survey, @question)
    end
    
    @question.reload
    assert_not @question.deleted?
    assert_redirected_to survey_path(@survey)
  end
end
