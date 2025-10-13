import React, { useState, useEffect } from 'react';
import { createRoot } from 'react-dom/client';

const QuestionList = (props) => {
  const [questions, setQuestions] = useState(props.questions || []);
  const [loading, setLoading] = useState(false);
  const [showDeleted, setShowDeleted] = useState(false);

  const fetchQuestions = async (roleId = "", includeDeleted = false) => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (roleId) params.append('role_id', roleId);
      if (includeDeleted) params.append('show_deleted', 'true');
      
      const url = `/surveys/${props.surveyId}/questions.json` + (params.toString() ? `?${params.toString()}` : "");
      const res = await fetch(url, { headers: { "Accept": "application/json" } });
      if (!res.ok) throw new Error("Failed to load questions");
      const data = await res.json();
      setQuestions(data);
    } catch (e) {
      console.error("Error loading questions", e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchQuestions("", showDeleted);
    
    // Handle role filter
    const selectId = props.filterSelectId;
    if (selectId) {
      const sel = document.getElementById(selectId);
      if (sel) {
        const handler = (e) => {
          fetchQuestions(e.target.value || "", showDeleted);
        };
        sel.addEventListener("change", handler);
        return () => sel.removeEventListener("change", handler);
      }
    }
  }, [props.surveyId, showDeleted]);

  useEffect(() => {
    // Handle tab filtering
    const tabs = document.querySelectorAll('.question-filter-tab');
    const handleTabClick = (e) => {
      const filter = e.target.dataset.filter;
      const newShowDeleted = filter === 'all';
      
      // Update tab styling
      tabs.forEach(tab => {
        if (tab === e.target) {
          tab.className = 'border-indigo-500 text-indigo-600 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm question-filter-tab';
        } else {
          tab.className = 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm question-filter-tab';
        }
      });
      
      setShowDeleted(newShowDeleted);
    };
    
    tabs.forEach(tab => {
      tab.addEventListener('click', handleTabClick);
    });
    
    return () => {
      tabs.forEach(tab => {
        tab.removeEventListener('click', handleTabClick);
      });
    };
  }, []);

  const handleDelete = async (questionId) => {
    if (!confirm('Are you sure you want to delete this question?')) {
      return;
    }

    const csrfTokenElement = document.querySelector('meta[name="csrf-token"]');
    const csrfToken = csrfTokenElement ? csrfTokenElement.content : '';
    
    try {
      const response = await fetch(`/surveys/${props.surveyId}/questions/${questionId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': csrfToken,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });
      
      if (response.ok) {
        // Refresh the list to show updated status
        const roleSelect = document.getElementById(props.filterSelectId);
        const currentRoleId = roleSelect ? roleSelect.value : "";
        fetchQuestions(currentRoleId, showDeleted);
      } else {
        console.error('Failed to delete question:', response.status);
      }
    } catch (error) {
      console.error('Error deleting question:', error);
    }
  };

  const handleRestore = async (questionId) => {
    if (!confirm('Are you sure you want to restore this question?')) {
      return;
    }

    const csrfTokenElement = document.querySelector('meta[name="csrf-token"]');
    const csrfToken = csrfTokenElement ? csrfTokenElement.content : '';
    
    try {
      const response = await fetch(`/surveys/${props.surveyId}/questions/${questionId}/restore`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': csrfToken,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });
      
      if (response.ok) {
        // Refresh the list to show updated status
        const roleSelect = document.getElementById(props.filterSelectId);
        const currentRoleId = roleSelect ? roleSelect.value : "";
        fetchQuestions(currentRoleId, showDeleted);
      } else {
        console.error('Failed to restore question:', response.status);
      }
    } catch (error) {
      console.error('Error restoring question:', error);
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
        <li key={question.id} className={`py-4 ${question['deleted?'] ? 'opacity-60' : ''}`}>
          <div className="flex justify-between">
            <div>
              <div className="flex items-center space-x-2">
                <p className={`text-sm font-medium ${question['deleted?'] ? 'text-gray-500' : 'text-gray-900'}`}>
                  {question.content}
                </p>
                {question['deleted?'] && (
                  <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                    Deleted
                  </span>
                )}
              </div>
              <p className="text-sm text-gray-500">
                Type: {getQuestionTypeLabel(question.question_type)}
              </p>
              {question['deleted?'] && question.deleted_at && (
                <p className="text-xs text-red-500">Deleted on {question.deleted_at}</p>
              )}
            </div>
            <div className="flex space-x-2">
              {question['deleted?'] ? (
                <button
                  onClick={() => handleRestore(question.id)}
                  className="inline-flex items-center px-2 py-1 border border-transparent text-xs font-medium rounded text-green-700 bg-green-100 hover:bg-green-200"
                >
                  Restore
                </button>
              ) : (
                <>
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
                </>
              )}
            </div>
          </div>
        </li>
      ))}
    </ul>
  );
};

// Use a self-executing function to initialize the component
const initializeQuestionList = () => {
  const container = document.getElementById('question-list-container');
  if (!container || container.hasAttribute('data-react-initialized')) return;
  const surveyId = container.dataset.surveyId;
  const filterSelectId = container.dataset.filterSelectId;
  container.setAttribute('data-react-initialized', 'true');
  const root = createRoot(container);
  root.render(
    <QuestionList
      surveyId={surveyId}
      filterSelectId={filterSelectId}
      questions={[]}
    />
  );
};

// Try to initialize immediately
initializeQuestionList();

// Also listen for DOMContentLoaded
document.addEventListener('DOMContentLoaded', initializeQuestionList);

// Additionally listen for turbo:load event if using Turbo
document.addEventListener('turbo:load', initializeQuestionList);

export default QuestionList; 