import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';
import AddSurveyVariation from "./AddSurveyVariation";

const QuestionList = (props) => {
  const [questions, setQuestions] = useState(props.questions || []);
  const [variations, setVariations] = useState(props.variations || []);
  const [loading, setLoading] = useState(false);
  const [editingVariation, setEditingVariation] = useState(-1);
  // const [addingVariation, setAddingVariation] = useState(-1);

  const handleVariationAdded = (newVariation) => {
    setVariations((prev) => [...prev, newVariation]);
  };

  const handleVariationUpdated = (updatedVariation) => {
    setVariations((prev) =>
      [...prev.map((v) => {
        return (v.id === updatedVariation.id ? updatedVariation : v)
      })]
    );
    console.log('handleVariationUpdated', updatedVariation, variations)
  };

  const handleVariationDeleted = (deletedVariationId) => {
    setVariations((prev) => prev.filter((variation) => variation.id !== deletedVariationId));
  };

  const fetchQuestions = async () => {
    console.log('fetchQuestions')
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

  const fetchVariations = async () => {
    console.log('fetchVariations')
    setLoading(true);
    try {
      const response = await fetch(`/surveys/${props.surveyId}/survey_variations.json`);
      console.log('fetchVariations', response)
      if (response.ok) {
        const data = await response.json();
        console.log('data', data);
        setVariations(data);
      }
    } catch (error) {
      console.error('Error fetching variations:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (props.autoload && props.surveyId) {
      fetchQuestions();
      fetchVariations();
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
    <div>
      <div className="inline-flex items-center">
        <AddSurveyVariation
          surveyId={props.surveyId}
          onVariationAdded={handleVariationAdded}
          onToggleEditing={setEditingVariation}
          questions={questions}
          editingVariationId={editingVariation}
        />

        {
          variations.map((variation) => (
            <AddSurveyVariation
              key={variation.id}
              surveyId={props.surveyId}
              variation={variation}
              onVariationUpdated={handleVariationUpdated}
              onToggleEditing={setEditingVariation}
              questions={questions}
              editingVariationId={editingVariation}
              onVariationDeleted={handleVariationDeleted}
            />
          ))
        }

      </div>
      <ul className="divide-y divide-gray-200">
        {editingVariation < 0 ? questions.map(question => (
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
        )) : null}
      </ul>
    </div>
  );
};

// Use a self-executing function to initialize the component
const initializeQuestionList = () => {
  const container = document.getElementById('question-list-container');
  if (container && !container.hasAttribute('data-react-initialized')) {
    const surveyId = container.dataset.surveyId;
    const questionsData = JSON.parse(container.dataset.questions || '[]');
    const variationsData = JSON.parse(container.dataset.variations || '[]');
    const autoload = container.dataset.autoload === 'true';
    console.log('variationsData', variationsData)
    // Mark as initialized to prevent double initialization
    container.setAttribute('data-react-initialized', 'true');

    const root = createRoot(container);
    root.render(
      <QuestionList
        surveyId={surveyId}
        questions={questionsData}
        variations={variationsData}
        autoload={autoload}
      />
    );
  }
};

// Try to initialize immediately
initializeQuestionList();

// Also listen for DOMContentLoaded
document.addEventListener('DOMContentLoaded', initializeQuestionList);

// Additionally listen for turbo:load event if using Turbo
document.addEventListener('turbo:load', initializeQuestionList);

export default QuestionList;