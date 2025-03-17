# Proctor: Survey A/B Testing Engine

This is a coding challenge for implementing a Survey A/B Testing Engine. The goal is to implement logic to randomly assign users to different versions of a survey (A vs. B) and track their responses for analysis.

## Challenge Description

Your task is to implement the A/B testing functionality in this application. Specifically, you need to:

1. Modify the `take` action in the `SurveysController` to randomly assign users to either version A or B of a survey
2. Track which version (A or B) was shown to the user when they submit responses
3. Implement analytics to compare response data between the two versions

The boilerplate code provides a basic survey application with the ability to create surveys, add questions, and collect responses. Your job is to extend this functionality to support A/B testing.

## Technology Stack

- **Backend**: Ruby on Rails 7
- **Frontend**: React with esbuild
- **Styling**: Tailwind CSS
- **Database**: PostgreSQL

## Getting Started

### Prerequisites

- Ruby 3.1.3 or higher
- PostgreSQL
- Node.js and Yarn (for JavaScript and CSS processing)

### Setup Instructions (macOS)

1. Clone this repository
   ```
   git clone <repository-url>
   cd proctor
   ```

2. Install dependencies
   ```
   bundle install
   yarn install
   ```

3. Setup the database
   ```
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. Start the Rails server and build the frontend assets
   ```
   bin/dev
   ```

5. Visit `http://localhost:3000` in your browser

## Implementation Guidelines

### 1. Survey Version Assignment

When a user visits the `/surveys/:id/take` page, they should be randomly assigned to either version A or B of the survey. You can implement this in the `take` action of the `SurveysController`.

### 2. Response Tracking

When a user submits their responses, you should store which version of the survey they were shown. The `Response` model already has a `survey_version` attribute for this purpose.

### 3. Analytics

Implement a way to view and compare the responses between versions A and B. This could be a new controller action and view, or an extension of an existing one.

## React Components

The application uses React for the frontend. The main components are:

- **SurveyForm**: For creating and editing surveys
- **QuestionList**: For displaying and managing questions
- **TakeSurvey**: For taking surveys and submitting responses

These components are located in the `app/javascript/components` directory.

## Evaluation Criteria

Your solution will be evaluated based on:

1. Correctness of the A/B testing implementation
2. Code quality and organization
3. Test coverage (bonus)
4. User experience
5. Documentation

## Submission

Please submit your solution as a Git repository with clear instructions on how to run your code. Include any notes or explanations in the README or as comments in your code.

Good luck!
