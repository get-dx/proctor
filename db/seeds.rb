# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clear existing data
puts "Clearing existing data..."
Role.destroy_all
Survey.destroy_all
SurveyBranch.destroy_all
Question.destroy_all
BranchQuestion.destroy_all

# Create roles
roles = ["Data Engineer", "Frontend Engineer", "QA Engineer", "UX Designer", "Backend Engineer", "Product Manager", "UI Designer", "API Developer"].map do |role_name|
  Role.create!(name: role_name)
end

# Create engineering team survey
puts "Creating engineering team survey..."
engineering_survey = Survey.create!(
  title: "Engineering Team Satisfaction Survey",
  description: "This survey helps us understand the satisfaction and needs of our engineering team members."
)

# Create branches only for engineering roles
engineering_roles = roles.select { |role| role.name.downcase.include?('engineer') || role.name.downcase.include?('developer') }
engineering_survey_branches = engineering_roles.map do |role|
  SurveyBranch.create!(survey: engineering_survey, role: role, name: "#{role.name} Branch")
end

# Create questions for the engineering survey
puts "Creating questions for engineering survey..."
engineering_survey_questions = [
  {
    content: "How satisfied are you with the current development process?",
    question_type: "rating",
    position: 1,
    required: true
  },
  {
    content: "What programming languages do you use regularly?",
    question_type: "checkbox",
    position: 2,
    required: true,
    options: ["JavaScript", "TypeScript", "Ruby", "Python", "Java", "C#", "Go", "Rust", "PHP", "Swift", "Kotlin", "Other"]
  },
  {
    content: "How many years of experience do you have in software development?",
    question_type: "multiple_choice",
    position: 3,
    required: true,
    options: ["Less than 1 year", "1-3 years", "3-5 years", "5-10 years", "More than 10 years"]
  },
  {
    content: "What tools or resources would help you be more productive?",
    question_type: "text",
    position: 4,
    required: false
  },
  {
    content: "How satisfied are you with the current code review process?",
    question_type: "rating",
    position: 5,
    required: true
  },
  {
    content: "What aspects of our technical stack do you find most challenging?",
    question_type: "text",
    position: 6,
    required: false
  },
  {
    content: "How would you rate the quality of our documentation?",
    question_type: "rating",
    position: 7,
    required: true
  },
  {
    content: "What would you like to see improved in our engineering culture?",
    question_type: "text",
    position: 8,
    required: false
  },
  {
    content: "Which development methodology do you prefer?",
    question_type: "multiple_choice",
    position: 9,
    required: true,
    options: ["Scrum", "Kanban", "Extreme Programming (XP)", "Waterfall", "Hybrid approach", "Other"]
  },
  {
    content: "What tools do you use for project management?",
    question_type: "checkbox",
    position: 10,
    required: false,
    options: ["Jira", "Trello", "Asana", "GitHub Projects", "ClickUp", "Monday.com", "Notion", "Linear", "Other"]
  }
].map { |attrs| Question.create!(attrs) }

engineering_survey_branches.each do |branch|
  engineering_survey_questions.each do |question|
    BranchQuestion.create!(survey_branch: branch, question: question)
  end
end

# Create project retrospective survey
puts "Creating project retrospective survey..."
retrospective_survey = Survey.create!(
  title: "Project Retrospective",
  description: "Help us understand what went well and what could be improved in our recent project."
)

# Create branches for project-involved roles (exclude pure design roles for this survey)
project_roles = roles.reject { |role| role.name.downcase.include?('designer') }
project_retrospective_survey_branches = project_roles.map do |role|
  SurveyBranch.create!(survey: retrospective_survey, role: role, name: "#{role.name} Branch")
end

# Create questions for the retrospective survey
puts "Creating questions for retrospective survey..."
retro_questions = [
  {
    content: "How would you rate the overall success of the project?",
    question_type: "rating",
    position: 1,
    required: true
  },
  {
    content: "What aspects of the project went well?",
    question_type: "long_text",
    position: 2,
    required: true
  },
  {
    content: "What challenges did you face during the project?",
    question_type: "long_text",
    position: 3,
    required: true
  },
  {
    content: "How effective was the communication within the team?",
    question_type: "rating",
    position: 4,
    required: true
  },
  {
    content: "What tools or processes helped you the most during this project?",
    question_type: "text",
    position: 5,
    required: false
  },
  {
    content: "What would you do differently next time?",
    question_type: "long_text",
    position: 6,
    required: false
  },
  {
    content: "Which phase of the project was most challenging?",
    question_type: "multiple_choice",
    position: 7,
    required: true,
    options: ["Planning", "Design", "Development", "Testing", "Deployment", "Maintenance"]
  },
  {
    content: "Which team members contributed most significantly to the project's success?",
    question_type: "checkbox",
    position: 8,
    required: false,
    options: ["Project Manager", "Tech Lead", "Frontend Developers", "Backend Developers", "QA Engineers", "DevOps Engineers", "UX/UI Designers", "Product Managers"]
  },
  {
    content: "How would you describe the pace of the project?",
    question_type: "multiple_choice",
    position: 9,
    required: true,
    options: ["Too slow", "Just right", "Too fast", "Inconsistent"]
  },
  {
    content: "What skills did you develop or improve during this project?",
    question_type: "checkbox",
    position: 10,
    required: false,
    options: ["Technical skills", "Communication", "Problem-solving", "Time management", "Leadership", "Collaboration", "Adaptability", "Domain knowledge"]
  }
].map { |attrs| Question.create!(attrs) }

project_retrospective_survey_branches.each do |branch|
  retro_questions.each do |question|
    BranchQuestion.create!(survey_branch: branch, question: question)
  end
end

# Create customer feedback survey
puts "Creating customer feedback survey..."
customer_survey = Survey.create!(
  title: "Customer Satisfaction Survey",
  description: "We value your feedback! Please help us improve our products and services."
)

# Create branches for customer-facing roles
customer_facing_roles = roles.select { |role| 
  role.name.downcase.include?('product') || 
  role.name.downcase.include?('frontend') || 
  role.name.downcase.include?('ux') || 
  role.name.downcase.include?('ui') 
}
customer_survey_branches = customer_facing_roles.map do |role|
  SurveyBranch.create!(survey: customer_survey, role: role, name: "#{role.name} Branch")
end

# Create questions for the customer survey
puts "Creating questions for customer survey..."
customer_questions = [
  {
    content: "How satisfied are you with our product/service?",
    question_type: "rating",
    position: 1,
    required: true
  },
  {
    content: "How likely are you to recommend our product/service to others?",
    question_type: "rating",
    position: 2,
    required: true
  },
  {
    content: "Which features do you use most frequently?",
    question_type: "checkbox",
    position: 3,
    required: false,
    options: ["Feature A", "Feature B", "Feature C", "Feature D", "Feature E", "Other"]
  },
  {
    content: "How did you hear about our product/service?",
    question_type: "multiple_choice",
    position: 4,
    required: true,
    options: ["Search Engine", "Social Media", "Friend/Colleague", "Advertisement", "Blog/Article", "Other"]
  },
  {
    content: "What improvements would you like to see in our product/service?",
    question_type: "long_text",
    position: 5,
    required: false
  },
  {
    content: "How long have you been using our product/service?",
    question_type: "multiple_choice",
    position: 6,
    required: true,
    options: ["Less than a month", "1-6 months", "6-12 months", "1-2 years", "More than 2 years"]
  },
  {
    content: "What problems does our product/service solve for you?",
    question_type: "long_text",
    position: 7,
    required: false
  },
  {
    content: "Which alternative products/services did you consider?",
    question_type: "checkbox",
    position: 8,
    required: false,
    options: ["Competitor A", "Competitor B", "Competitor C", "Competitor D", "None", "Other"]
  }
].map { |attrs| Question.create!(attrs) }

customer_survey_branches.each do |branch|
  customer_questions.each do |question|
    BranchQuestion.create!(survey_branch: branch, question: question)
  end
end

# Create QA-specific survey
puts "Creating QA and testing survey..."
qa_survey = Survey.create!(
  title: "Quality Assurance & Testing Practices Survey",
  description: "Help us understand our testing processes and quality assurance practices."
)

# Create branches only for QA roles
qa_roles = roles.select { |role| role.name.downcase.include?('qa') || role.name.downcase.include?('engineer') }
qa_survey_branches = qa_roles.map do |role|
  SurveyBranch.create!(survey: qa_survey, role: role, name: "#{role.name} Branch")
end

# Create QA-specific questions
puts "Creating questions for QA survey..."
qa_questions = [
  {
    content: "How confident are you in our current testing coverage?",
    question_type: "rating",
    position: 1,
    required: true
  },
  {
    content: "Which types of testing do you regularly perform?",
    question_type: "checkbox",
    position: 2,
    required: true,
    options: ["Unit Testing", "Integration Testing", "End-to-End Testing", "Manual Testing", "Performance Testing", "Security Testing", "Accessibility Testing", "API Testing"]
  },
  {
    content: "What testing tools do you use most frequently?",
    question_type: "checkbox",
    position: 3,
    required: false,
    options: ["Jest", "Cypress", "Selenium", "Postman", "JMeter", "SonarQube", "TestRail", "Jira", "Other"]
  },
  {
    content: "How would you rate the quality of our bug reporting process?",
    question_type: "rating",
    position: 4,
    required: true
  },
  {
    content: "What are the biggest challenges in maintaining test quality?",
    question_type: "long_text",
    position: 5,
    required: false
  },
  {
    content: "How often do you encounter flaky tests?",
    question_type: "multiple_choice",
    position: 6,
    required: true,
    options: ["Never", "Rarely", "Sometimes", "Often", "Very often"]
  },
  {
    content: "What improvements would help you be more effective in testing?",
    question_type: "text",
    position: 7,
    required: false
  }
].map { |attrs| Question.create!(attrs) }

qa_survey_branches.each do |branch|
  qa_questions.each do |question|
    BranchQuestion.create!(survey_branch: branch, question: question)
  end
end

puts "Seed data created successfully!"
