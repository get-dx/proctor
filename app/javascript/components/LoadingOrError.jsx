import React from "react";

const LoadingOrError = ({ loading, error }) => {
  if (loading) {
    return <p>Loading...</p>;
  }

  if (error) {
    return <p style={{ color: "red" }}>Error: {error}</p>;
  }

  return null;
};

export default LoadingOrError;