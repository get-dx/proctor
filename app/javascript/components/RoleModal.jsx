import React from "react";
import RoleSelect from "./RoleSelect";
import { createRoot } from 'react-dom/client';

const RoleModal = ({ open, roles, value, onSelect, onClose }) => {
  if (!open) return null;
  return (
    <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
      <div className="bg-white p-6 rounded shadow-lg min-w-[300px]">
        <h2 className="text-lg font-bold mb-4">Choose Your Role</h2>
        <RoleSelect roles={roles} value={value} onChange={onSelect} />
        <button
          onClick={onClose}
          className="mt-4 px-4 py-2 bg-gray-200 rounded hover:bg-gray-300 text-gray-700"
        >
          Cancel
        </button>
      </div>
    </div>
  );
};

// Use a self-executing function to initialize the component
const initializeRoleModal = () => {
  const container = document.getElementById('role-modal-root');
  const roles = JSON.parse(container.dataset.roles);
  if (container && !container.hasAttribute('data-react-initialized')) {
    
    // Mark as initialized to prevent double initialization
    container.setAttribute('data-react-initialized', 'true');
    
    const root = createRoot(container);
    document.querySelectorAll(".take-survey-link").forEach(link => {
        link.addEventListener("click", function(e) {
        e.preventDefault();
        const surveyId = this.dataset.surveyId;
        // Render your React RoleModal, passing surveyId as a prop
        root.render(
            <RoleModal
            open={true}
            roles={roles} // Provide actual roles array
            value={null} // Provide actual value if needed
            onSelect={() => {}} // Provide actual handler
            onClose={() => {}} // Provide actual handler
            />,
            document.getElementById("role-modal-root")
        )
        });
    });
  }
};

// Try to initialize immediately
initializeRoleModal();

// Also listen for DOMContentLoaded
document.addEventListener('DOMContentLoaded', initializeRoleModal);

// Additionally listen for turbo:load event if using Turbo
document.addEventListener('turbo:load', initializeRoleModal);

export default RoleModal;
