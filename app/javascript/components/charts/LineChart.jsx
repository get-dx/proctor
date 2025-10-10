import React from 'react';
import { Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, Filler } from 'chart.js';
import { CHART_COLORS, CHART_OPTIONS } from './ChartColors';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, Filler);

const LineChart = ({ data, title, height = 300, fill = false }) => {
  // Handle both object and array data formats
  let labels, values;
  if (Array.isArray(data)) {
    labels = data.map(item => item[0]);
    values = data.map(item => item[1]);
  } else {
    labels = Object.keys(data);
    values = Object.values(data);
  }

  const chartData = {
    labels: labels,
    datasets: [
      {
        data: values,
        backgroundColor: fill ? CHART_COLORS.gradients.blue.backgroundColor : 'transparent',
        borderColor: CHART_COLORS.gradients.blue.borderColor,
        borderWidth: 3,
        fill: fill,
        tension: 0.4,
        pointBackgroundColor: CHART_COLORS.gradients.blue.borderColor,
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: 5,
        pointHoverRadius: 7,
      },
    ],
  };

  const options = {
    ...CHART_OPTIONS,
    plugins: {
      ...CHART_OPTIONS.plugins,
      title: {
        display: !!title,
        text: title,
        font: {
          size: 16,
          weight: 'bold',
        },
        padding: 20,
      },
      legend: {
        display: false, // Hide legend for line charts unless needed
      },
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: {
          color: 'rgba(0, 0, 0, 0.1)',
        },
      },
      x: {
        grid: {
          color: 'rgba(0, 0, 0, 0.1)',
        },
      },
    },
  };

  return (
    <div style={{ height: `${height}px` }}>
      <Line data={chartData} options={options} />
    </div>
  );
};

export default LineChart;