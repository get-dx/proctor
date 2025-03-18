# Proctor: Basic Survey Application 

This is a coding challenge created by DX. It houses a basic survey application that will serve as the basis for the challenge.

## Challenge Description
The scenario: We want to be able customize questions in the survey depending on the role of the person responding (i.e. Data Engineer, Frontend Engineer, Product Manager, etc.).

Here's what we'd like to see:
* Implement a way to define the different branches of a survey and the questions that are shown or hidden for each branch
* Update the respondent experience to collect their role and then display the appropriate questions based on the branch
* (If time allows) Add a way to analyze the response data between the different branches

The boilerplate code provides a very basic survey application with the ability to create surveys, add questions, and collect responses. Your job is to extend this functionality to support branching.

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
   # Install nvm (Node Version Manager) for better Node.js version management
   brew install nvm
   
   # Create NVM's working directory if it doesn't exist
   mkdir -p ~/.nvm
   
   # Add NVM to your shell profile
   echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
   echo '[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"' >> ~/.zshrc
   echo '[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"' >> ~/.zshrc
   
   # Source the updated profile
   source ~/.zshrc
   
   # Install and use Node.js version 20 (compatible with the project dependencies)
   nvm install 20
   nvm use 20
   
   # Verify installation
   node -v
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
