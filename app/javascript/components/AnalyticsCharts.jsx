import React from 'react';
import PieChart from './charts/PieChart';
import BarChart from './charts/BarChart';
import LineChart from './charts/LineChart';

const AnalyticsCharts = ({ chartData }) => {
  if (!chartData) {
    return <div className="text-center text-gray-500 py-8">Loading charts...</div>;
  }

  const {
    responses_by_branch,
    completion_rates,
    response_timeline,
    question_types,
    daily_responses
  } = chartData;

  return (
    <div>
      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        {/* Responses by Branch Chart */}
        <div className="bg-white shadow overflow-hidden sm:rounded-lg">
          <div className="px-4 py-5 sm:px-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">Responses by Role</h3>
            <p className="mt-1 text-sm text-gray-500">Total responses received per role</p>
          </div>
          <div className="px-4 py-5">
            <PieChart data={responses_by_branch} height={300} />
          </div>
        </div>

        {/* Completion Rates Chart */}
        <div className="bg-white shadow overflow-hidden sm:rounded-lg">
          <div className="px-4 py-5 sm:px-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">Completion Rates by Role</h3>
            <p className="mt-1 text-sm text-gray-500">Percentage of questions answered per role</p>
          </div>
          <div className="px-4 py-5">
            <BarChart data={completion_rates} height={300} suffix="%" />
          </div>
        </div>
      </div>

      {/* Timeline Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        {/* Response Timeline */}
        <div className="bg-white shadow overflow-hidden sm:rounded-lg">
          <div className="px-4 py-5 sm:px-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">Response Timeline</h3>
            <p className="mt-1 text-sm text-gray-500">Responses received over the last 14 days</p>
          </div>
          <div className="px-4 py-5">
            <LineChart data={response_timeline} height={300} />
          </div>
        </div>

        {/* Question Types Distribution */}
        <div className="bg-white shadow overflow-hidden sm:rounded-lg">
          <div className="px-4 py-5 sm:px-6">
            <h3 className="text-lg leading-6 font-medium text-gray-900">Question Types</h3>
            <p className="mt-1 text-sm text-gray-500">Distribution of question types in this survey</p>
          </div>
          <div className="px-4 py-5">
            <PieChart data={question_types} height={300} />
          </div>
        </div>
      </div>

      {/* Daily Activity Chart */}
      <div className="bg-white shadow overflow-hidden sm:rounded-lg mb-8">
        <div className="px-4 py-5 sm:px-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">Daily Activity</h3>
          <p className="mt-1 text-sm text-gray-500">Response activity over the last 7 days</p>
        </div>
        <div className="px-4 py-5">
          <LineChart data={daily_responses} height={250} fill={true} />
        </div>
      </div>
    </div>
  );
};

export default AnalyticsCharts;