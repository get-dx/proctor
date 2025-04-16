import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';

const RoleForm = (props) => {
  const [name, setName] = useState(props.role?.name || '');
  const [errors, setErrors] = useState([]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const url = props.role?.id ? `/roles/${props.role.id}` : '/roles';
    const method = props.role?.id ? 'PATCH' : 'POST';
    
    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({
          role: { name }
        })
      });
      
      if (response.ok) {
        window.location.href = props.role?.id ? `/roles/${props.role.id}` : '/roles';
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
                {errors.length} {errors.length === 1 ? 'error' : 'errors'} prohibited this role from being saved:
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
          <label htmlFor="name" className="block text-sm font-medium text-gray-700">Name</label>
          <div className="mt-1">
            <input
              type="text"
              id="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
            />
          </div>
        </div>

        <div className="mt-6 flex justify-end">
          <a href="/roles" className="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Cancel
          </a>
          <button
            type="submit"
            className="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            {props.role?.id ? 'Update Role' : 'Create Role'}
          </button>
        </div>
      </form>
    </div>
  );
};

// Use a self-executing function to initialize the component
const initializeRoleForm = () => {
  const container = document.getElementById('role-form-container');
  if (container && !container.hasAttribute('data-react-initialized')) {
    const roleData = JSON.parse(container.dataset.role || '{}');
    
    // Mark as initialized to prevent double initialization
    container.setAttribute('data-react-initialized', 'true');
    
    const root = createRoot(container);
    root.render(<RoleForm role={roleData} />);
  }
};

// Try to initialize immediately
initializeRoleForm();

// Also listen for DOMContentLoaded
document.addEventListener('DOMContentLoaded', initializeRoleForm);

// Additionally listen for turbo:load event if using Turbo
document.addEventListener('turbo:load', initializeRoleForm);

export default RoleForm; 
