# Proctor: Survey A/B Testing Engine

This is a coding challenge for implementing a Survey A/B Testing Engine. Do not spend more tha 4 hours on your implementation.

## Challenge Description

Your task is to implement A/B testing functionality in this application.

The boilerplate code provides a very basic survey application with the ability to create surveys, add questions, and collect responses. Your job is to extend this functionality to support A/B testing. The testing should be primarily based upon copy changes, question types, question order, or other survey enhancement. It should not be testing any UI differences like button colors or positioning. The implementation should be easily demo-able.

Here are a few ideas of things that you could do to accomplish this:
* A/B testing could happen on the question level or on the survey level
* There could be a way to visualize the different responses and the variant effectiveness


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

Any and all existing code or seed data can be edited in any way. Anything that's here is purely to serve as a functional starting point to begin building off of.

## Evaluation Criteria
The purpose of this excercise is not to evaluate any sort of exactness in implementation. We want to evaluate how you operate in ambiguity and start a dialogue around your architecture, the things you feel you did well, and what you think could be better. We hope to see your thought process and how you arrived at the key decisions, the tradeoffs, and other new ideas.

## Submission

Please submit your solution as a .zip file or Github repo with clear instructions on how to run your code. Include any notes or explanations in the README or as comments in your code.

Good luck!
