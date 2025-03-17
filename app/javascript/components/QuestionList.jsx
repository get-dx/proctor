import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';

const QuestionList = (props) => {
  const [questions, setQuestions] = useState(props.questions || []);
  const [loading, setLoading] = useState(false);

  const fetchQuestions = async () => {
    setLoading(true);
    try {
      const response = await fetch(`/surveys/${props.surveyId}/questions.json`);
      if (response.ok) {
        const data = await response.json();
        setQuestions(data);
      }
    } catch (error) {
      console.error('Error fetching questions:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (props.autoload && props.surveyId) {
      fetchQuestions();
    }
  }, [props.surveyId]);

  const handleDelete = async (questionId) => {
    if (!confirm('Are you sure you want to delete this question?')) {
      return;
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    
    try {
      const response = await fetch(`/surveys/${props.surveyId}/questions/${questionId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': csrfToken
        }
      });
      
      if (response.ok) {
        setQuestions(questions.filter(q => q.id !== questionId));
      }
    } catch (error) {
      console.error('Error deleting question:', error);
    }
  };

  const getQuestionTypeLabel = (type) => {
    return type.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
  };

  if (loading) {
    return <div className="text-center py-4">Loading questions...</div>;
  }

  if (questions.length === 0) {
    return (
      <div className="text-center py-4">
        <p className="text-gray-500">No questions added to this survey yet.</p>
      </div>
    );
  }

  return (
    <ul className="divide-y divide-gray-200">
      {questions.map(question => (
        <li key={question.id} className="py-4">
          <div className="flex justify-between">
            <div>
              <p className="text-sm font-medium text-gray-900">
                {question.content}
              </p>
              <p className="text-sm text-gray-500">
                Type: {getQuestionTypeLabel(question.question_type)}
              </p>
            </div>
            <div className="flex space-x-2">
              <a 
                href={`/surveys/${props.surveyId}/questions/${question.id}/edit`}
                className="inline-flex items-center px-2 py-1 border border-transparent text-xs font-medium rounded text-yellow-700 bg-yellow-100 hover:bg-yellow-200"
              >
                Edit
              </a>
              <button
                onClick={() => handleDelete(question.id)}
                className="inline-flex items-center px-2 py-1 border border-transparent text-xs font-medium rounded text-red-700 bg-red-100 hover:bg-red-200"
              >
                Delete
              </button>
            </div>
          </div>
        </li>
      ))}
    </ul>
  );
};

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('question-list-container');
  if (container) {
    const surveyId = container.dataset.surveyId;
    const questionsData = JSON.parse(container.dataset.questions || '[]');
    const autoload = container.dataset.autoload === 'true';
    
    const root = createRoot(container);
    root.render(
      <QuestionList 
        surveyId={surveyId} 
        questions={questionsData}
        autoload={autoload}
      />
    );
  }
});

export default QuestionList; 