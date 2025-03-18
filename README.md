# Proctor: Basic Survey Application 

This is a coding challenge created by DX. It houses a basic survey application that will serve as the basis for the challenge.

## Challenge Description
The scenario: We want to be able run surveys and effectively test how different versions of the same question perform. The versions can differ in the way the questions are phrased in the prompt and/or the options.

Here's what we'd like to see:
* Implement a UI to manage A/B testing for different survey question phrasings
* Update the respondent experience to take A/B testing into account
* Add a way to easily analyze the response data between different variants

The boilerplate code provides a very basic survey application with the ability to create surveys, add questions, and collect responses. Your job is to extend this functionality to support A/B testing.

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
- Node.js (for JavaScript and CSS processing)

### Setup Instructions (macOS)

#### Install Dependencies with Homebrew

1. Install Homebrew (if not already installed)
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Ruby via rbenv
   ```bash
   brew install rbenv ruby-build
   echo 'eval "$(rbenv init -)"' >> ~/.zshrc  # or ~/.bash_profile for bash users
   source ~/.zshrc  # or source ~/.bash_profile for bash users
   rbenv install 3.1.3
   rbenv global 3.1.3
   ruby -v  # Verify installation
   ```

3. Install PostgreSQL
   ```bash
   brew install postgresql@15
   brew services start postgresql@15
   ```

4. Install Node.js
   ```bash
   brew install node
   ```

#### Project Setup

1. Clone this repository
   ```bash
   git clone <repository-url>
   cd proctor
   ```

2. Install Ruby dependencies
   ```bash
   gem install bundler
   bundle install
   ```

3. Install JavaScript dependencies
   ```bash
   npm install
   ```

4. Setup the database
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

5. Start the Rails server and build the frontend assets
   ```bash
   bin/dev
   ```

6. Visit `http://localhost:3000` in your browser

## React Components

The application uses React for the frontend. The main components are:

- **SurveyForm**: For creating and editing surveys
- **QuestionList**: For displaying and managing questions
- **TakeSurvey**: For taking surveys and submitting responses

These components are located in the `app/javascript/components` directory.

## Submission

Please submit your solution as a .zip file or Github repo with clear instructions on how to run your code. Include any notes or explanations in the README or as comments in your code.

Good luck!
