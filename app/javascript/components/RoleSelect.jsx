import React from "react";
import { createRoot } from 'react-dom/client';

const RoleSelect = ({ roles, value, onChange, label = "Select Role" }) => {
  return (
    <div className="mb-4">
      <label htmlFor="role-select" className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <select
        id="role-select"
        value={value}
        onChange={e => onChange(e.target.value)}
        className="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring focus:border-blue-300"
      >
        <option value="">-- Choose a role --</option>
        {roles.map(role => (
                <option key={role.id} value={role.id}>
        {role.name}
      </option>
        ))}
      </select>
    </div>
  );
};

export default RoleSelect;
