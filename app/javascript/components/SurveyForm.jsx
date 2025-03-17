import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';

const SurveyForm = (props) => {
  const [title, setTitle] = useState(props.survey?.title || '');
  const [description, setDescription] = useState(props.survey?.description || '');
  const [errors, setErrors] = useState([]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const url = props.survey?.id ? `/surveys/${props.survey.id}` : '/surveys';
    const method = props.survey?.id ? 'PATCH' : 'POST';
    
    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({
          survey: {
            title,
            description
          }
        })
      });
      
      if (response.ok) {
        window.location.href = props.survey?.id ? `/surveys/${props.survey.id}` : '/surveys';
      } else {
        const data = await response.json();
        setErrors(data.errors || ['An error occurred']);
      }
    } catch (error) {
      setErrors(['An error occurred']);
    }
  };

  return (
    <div className="space-y-6">
      {errors.length > 0 && (
        <div className="bg-red-50 p-4 rounded-md">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-red-800">
                {errors.length} {errors.length === 1 ? 'error' : 'errors'} prohibited this survey from being saved:
              </h3>
              <div className="mt-2 text-sm text-red-700">
                <ul className="list-disc pl-5 space-y-1">
                  {errors.map((error, index) => (
                    <li key={index}>{error}</li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="title" className="block text-sm font-medium text-gray-700">Title</label>
          <div className="mt-1">
            <input
              type="text"
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
            />
          </div>
        </div>

        <div className="mt-6">
          <label htmlFor="description" className="block text-sm font-medium text-gray-700">Description</label>
          <div className="mt-1">
            <textarea
              id="description"
              rows={4}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
            />
          </div>
          <p className="mt-2 text-sm text-gray-500">
            Brief description of the survey's purpose.
          </p>
        </div>

        <div className="mt-6 flex justify-end">
          <a href="/surveys" className="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Cancel
          </a>
          <button
            type="submit"
            className="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {props.survey?.id ? 'Update Survey' : 'Create Survey'}
          </button>
        </div>
      </form>
    </div>
  );
};

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('survey-form-container');
  if (container) {
    const surveyData = JSON.parse(container.dataset.survey || '{}');
    const root = createRoot(container);
    root.render(<SurveyForm survey={surveyData} />);
  }
});

export default SurveyForm; 