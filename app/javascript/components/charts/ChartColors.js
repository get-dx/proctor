// Consistent color scheme for all charts
export const CHART_COLORS = {
  primary: ['#6366f1', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4'],
  gradients: {
    blue: {
      backgroundColor: 'rgba(99, 102, 241, 0.2)',
      borderColor: 'rgba(99, 102, 241, 1)'
    },
    green: {
      backgroundColor: 'rgba(16, 185, 129, 0.2)', 
      borderColor: 'rgba(16, 185, 129, 1)'
    }
  }
};

export const CHART_OPTIONS = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom',
      labels: {
        padding: 20,
        usePointStyle: true
      }
    }
  }
};