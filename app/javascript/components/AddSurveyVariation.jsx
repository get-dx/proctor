import React, { useState, useEffect } from "react";

const AddSurveyVariation = ({ surveyId, variation, onVariationAdded, onVariationUpdated, onToggleEditing, questions, editingVariationId, onVariationDeleted }) => {
  const [name, setName] = useState(variation ? variation.name : "");
  const [loading, setLoading] = useState(false);
  const [editingVariation, setEditingVariation] = useState(-1);
  const [error, setError] = useState(null);
  const [questionVisibility, setQuestionVisibility] = useState({});

  useEffect(() => {
    // Initialize question visibility based on the provided variation or default to all visible
    if (variation) {
      const visibility = questions.reduce((acc, question) => {
        acc[question.id] = variation.question_ids.includes(question.id); // Show if included in variation
        return acc;
      }, {});
      setQuestionVisibility(visibility);
    } else {
      const visibility = questions.reduce((acc, question) => {
        acc[question.id] = true; // Default to "show" (checked)
        return acc;
      }, {});
      setQuestionVisibility(visibility);
    }
  }, [variation, questions]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    try {
      const visibleQuestionIds = Object.keys(questionVisibility).filter(
        (id) => questionVisibility[id]
      );

      const url = variation
        ? `/surveys/${surveyId}/survey_variations/${variation.id}`
        : `/surveys/${surveyId}/survey_variations`;

      const method = variation ? "PUT" : "POST";

      const response = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ name, question_ids: visibleQuestionIds }),
      });

      if (!response.ok) {
        throw new Error(variation ? "Failed to update variation" : "Failed to add variation");
      }

      const data = await response.json();
      if (variation) {
        variation = data;
        onVariationUpdated(data); // Notify parent component of the updated variation
        toggleEditing(variation)
      } else {
        onVariationAdded(data); // Notify parent component of the new variation
      }

      setEditingVariation(-1); // Close the form
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (variationId) => {
    if (!window.confirm("Are you sure you want to delete this survey variation?")) {
      return;
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    try {
      const response = await fetch(`/surveys/${surveyId}/survey_variations/${variationId}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": csrfToken,
        },
      });

      if (!response.ok) {
        throw new Error("Failed to delete survey variation");
      }

      alert("Survey variation deleted successfully");
      onVariationDeleted(variationId); // Notify parent component to remove the variation from the list
      setEditingVariation(-1); // Close the form
      toggleEditing()
    } catch (err) {
      console.error("Error deleting survey variation:", err);
      alert("An error occurred while deleting the survey variation.");
    }
  };

  const toggleEditing = (variation) => {

    if (!variation) {
      console.log("No variation provided", editingVariationId);
      if (editingVariationId === Number.MAX_SAFE_INTEGER) {
        setEditingVariation(-1);
        onToggleEditing(-1);
      } else {
        setEditingVariation(Number.MAX_SAFE_INTEGER);
        onToggleEditing(Number.MAX_SAFE_INTEGER);
      }
      return
    }

    console.log(editingVariationId, variation.id)
    if (editingVariationId === variation.id) {
      setEditingVariation(-1);
      onToggleEditing(-1);
    } else {
      setEditingVariation(variation.id);
      onToggleEditing(variation.id);
    }
  };

  const handleCheckboxChange = (questionId) => {
    setQuestionVisibility((prev) => ({
      ...prev,
      [questionId]: !prev[questionId],
    }));
  };

  const classNames = `inline-flex items-center ${variation ? 'ml-2' : ''} px-3 py-1 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700`

  const buttonBaseClass =
  "inline-flex items-center px-3 py-1 border border-transparent text-sm font-medium rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2";

  const buttonColors = {
    primary: "text-white bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500",
    secondary: "text-gray-700 bg-white border-gray-300 hover:bg-gray-50 focus:ring-indigo-500",
    danger: "text-white bg-red-600 hover:bg-red-700 focus:ring-red-500",
  };

  return (
    <div>
      {
        editingVariationId === -1 ?
          <button
            className={classNames}
            onClick={() => { toggleEditing(variation) }}
          >
            {variation ? `Edit Variation (${name})` : "Add a Variation"}
          </button>
          : null
      }
      {editingVariation && editingVariationId === (variation ? variation.id : Number.MAX_SAFE_INTEGER) ? (
        <form onSubmit={handleSubmit}>
          <div>
            <label className="block mb-2 text-sm font-medium text-gray-900" htmlFor="variation-name">Variation Name:</label>
            <input
              className="border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
              id="variation-name"
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
            />
          </div>
          <div className="mt-4">
            <h4>Toggle Question Visibility</h4>
            <ul className="mb-5 mt-2">
              {questions.map((question) => (
                <li className="mb-2" key={question.id}>
                  <label className="switch">
                    <input
                      className="mr-2"
                      type="checkbox"
                      checked={questionVisibility[question.id]}
                      onChange={() => handleCheckboxChange(question.id)}
                    />
                    <span className="slider"></span>
                  </label>
                  {question.content}
                </li>
              ))}
            </ul>
          </div>
          <button
            onClick={() => {
              toggleEditing(variation);
            }}
            className={`${buttonBaseClass} ${buttonColors.secondary}`}
            >
            Cancel
          </button>

          <button
            className={`${buttonBaseClass} ${buttonColors.primary} ml-3`}
            type="submit"
            disabled={loading}
          >
            {loading ? (variation ? "Updating..." : "Adding...") : variation ? "Update Variation" : "Add Variation"}
          </button>

          {variation ?
            <button
              className={`${buttonBaseClass} ${buttonColors.danger} ml-3`}
              onClick={() => handleDelete(variation.id)}
            >
              Delete
            </button>
            : null}
        </form>
      ) : null}

      {error && <p style={{ color: "red" }}>{error}</p>}
    </div>
  );
};

export default AddSurveyVariation;