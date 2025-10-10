// Import all React components here
import React from "react"
import { createRoot } from "react-dom/client"
import SurveyForm from "./SurveyForm"
import QuestionList from "./QuestionList"
import TakeSurvey from "./TakeSurvey"
import RoleModal from "./RoleModal"
import RoleSelect from "./RoleSelect"
import AnalyticsCharts from "./AnalyticsCharts"

// Initialize React components when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  // Initialize AnalyticsCharts component
  const analyticsChartsElement = document.getElementById('analytics-charts');
  if (analyticsChartsElement) {
    const chartData = JSON.parse(analyticsChartsElement.dataset.chartData);
    const root = createRoot(analyticsChartsElement);
    root.render(<AnalyticsCharts chartData={chartData} />);
  }
});

// Export components for use elsewhere if needed
export { SurveyForm, QuestionList, TakeSurvey, RoleModal, RoleSelect, AnalyticsCharts } 