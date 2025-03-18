# Proctor: Survey A/B Testing Engine

This is a coding challenge for implementing a Survey A/B Testing Engine.

## Challenge Description

Your task is to implement A/B testing functionality in this application.

The boilerplate code provides a very basic survey application with the ability to create surveys, add questions, and collect responses. Your job is to extend this functionality to support A/B testing.

Here's what we'd like to see:
* Implement a UI to manage A/B testing for different survey question phrasings
* Update the respondent experience to take A/B testing into account
* Add a way to easily analyze the response data between different variants

Any and all existing code or seed data can be edited in any way. Anything that's here is purely to serve as a functional starting point to begin building off of.

## Evaluation Criteria
The purpose of this exercise is to evaluate how you would implement a moderately complex feature, consider tradeoffs, and explain your thinking on a real project. We are not evaluating your ability to implement algorithms from scratch — feel free to use tools or libraries that you would reach for in your actual day to day work.

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

## React Components

The application uses React for the frontend. The main components are:

- **SurveyForm**: For creating and editing surveys
- **QuestionList**: For displaying and managing questions
- **TakeSurvey**: For taking surveys and submitting responses

These components are located in the `app/javascript/components` directory.

## Submission

Please submit your solution as a .zip file or Github repo with clear instructions on how to run your code. Include any notes or explanations in the README or as comments in your code.

Good luck!
