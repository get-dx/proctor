# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clear existing data
puts "Clearing existing data..."
Response.destroy_all
Question.destroy_all
Survey.destroy_all
Role.destroy_all
QuestionRole.destroy_all

# Create roles
puts "Creating roles..."
data_engineer = Role.create!(name: "Data Engineer")
frontend_engineer = Role.create!(name: "Frontend Engineer")
product_manager = Role.create!(name: "Product Manager")
customer = Role.create!(name: "Customer")

# Create engineering team survey
puts "Creating engineering team survey..."
engineering_survey = Survey.create!(
  title: "Engineering Team Satisfaction Survey",
  description: "This survey helps us understand the satisfaction and needs of our engineering team members."
)

# Create questions for the engineering survey
puts "Creating questions for engineering survey..."
questions = [
  {
    content: "How satisfied are you with the current development process?",
    question_type: "rating",
    position: 1,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "What programming languages do you use regularly?",
    question_type: "checkbox",
    position: 2,
    required: true,
    options: ["JavaScript", "TypeScript", "Ruby", "Python", "Java", "C#", "Go", "Rust", "PHP", "Swift", "Kotlin", "Other"],
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "How many years of experience do you have in software development?",
    question_type: "multiple_choice",
    position: 3,
    required: true,
    options: ["Less than 1 year", "1-3 years", "3-5 years", "5-10 years", "More than 10 years"],
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "What tools or resources would help you be more productive?",
    question_type: "text",
    position: 4,
    required: false,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "How satisfied are you with the current code review process?",
    question_type: "rating",
    position: 5,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "What aspects of our technical stack do you find most challenging?",
    question_type: "text",
    position: 6,
    required: false,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "How would you rate the quality of our documentation?",
    question_type: "rating",
    position: 7,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "What would you like to see improved in our engineering culture?",
    question_type: "text",
    position: 8,
    required: false,
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "Which development methodology do you prefer?",
    question_type: "multiple_choice",
    position: 9,
    required: true,
    options: ["Scrum", "Kanban", "Extreme Programming (XP)", "Waterfall", "Hybrid approach", "Other"],
    role_ids: [data_engineer.id, frontend_engineer.id]
  },
  {
    content: "What tools do you use for project management?",
    question_type: "checkbox",
    position: 10,
    required: false,
    options: ["Jira", "Trello", "Asana", "GitHub Projects", "ClickUp", "Monday.com", "Notion", "Linear", "Other"],
    role_ids: [data_engineer.id, frontend_engineer.id]
  }
]

questions.each do |question_attrs|
  engineering_survey.questions.create!(question_attrs)
end

# Create project retrospective survey
puts "Creating project retrospective survey..."
retrospective_survey = Survey.create!(
  title: "Project Retrospective",
  description: "Help us understand what went well and what could be improved in our recent project."
)

# Create questions for the retrospective survey
puts "Creating questions for retrospective survey..."
retro_questions = [
  {
    content: "How would you rate the overall success of the project?",
    question_type: "rating",
    position: 1,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "What aspects of the project went well?",
    question_type: "long_text",
    position: 2,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "What challenges did you face during the project?",
    question_type: "long_text",
    position: 3,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "How effective was the communication within the team?",
    question_type: "rating",
    position: 4,
    required: true,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "What tools or processes helped you the most during this project?",
    question_type: "text",
    position: 5,
    required: false,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "What would you do differently next time?",
    question_type: "long_text",
    position: 6,
    required: false,
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "Which phase of the project was most challenging?",
    question_type: "multiple_choice",
    position: 7,
    required: true,
    options: ["Planning", "Design", "Development", "Testing", "Deployment", "Maintenance"],
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "Which team members contributed most significantly to the project's success?",
    question_type: "checkbox",
    position: 8,
    required: false,
    options: ["Project Manager", "Tech Lead", "Frontend Developers", "Backend Developers", "QA Engineers", "DevOps Engineers", "UX/UI Designers", "Product Managers"],
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "How would you describe the pace of the project?",
    question_type: "multiple_choice",
    position: 9,
    required: true,
    options: ["Too slow", "Just right", "Too fast", "Inconsistent"],
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  },
  {
    content: "What skills did you develop or improve during this project?",
    question_type: "checkbox",
    position: 10,
    required: false,
    options: ["Technical skills", "Communication", "Problem-solving", "Time management", "Leadership", "Collaboration", "Adaptability", "Domain knowledge"],
    role_ids: [data_engineer.id, frontend_engineer.id, product_manager.id]
  }
]

retro_questions.each do |question_attrs|
  retrospective_survey.questions.create!(question_attrs)
end

# Create customer feedback survey
puts "Creating customer feedback survey..."
customer_survey = Survey.create!(
  title: "Customer Satisfaction Survey",
  description: "We value your feedback! Please help us improve our products and services."
)

# Create questions for the customer survey
puts "Creating questions for customer survey..."
customer_questions = [
  {
    content: "How satisfied are you with our product/service?",
    question_type: "rating",
    position: 1,
    required: true,
    role_ids: [customer.id]
  },
  {
    content: "How likely are you to recommend our product/service to others?",
    question_type: "rating",
    position: 2,
    required: true,
    role_ids: [customer.id]
  },
  {
    content: "Which features do you use most frequently?",
    question_type: "checkbox",
    position: 3,
    required: false,
    options: ["Feature A", "Feature B", "Feature C", "Feature D", "Feature E", "Other"],
    role_ids: [customer.id]
  },
  {
    content: "How did you hear about our product/service?",
    question_type: "multiple_choice",
    position: 4,
    required: true,
    options: ["Search Engine", "Social Media", "Friend/Colleague", "Advertisement", "Blog/Article", "Other"],
    role_ids: [customer.id]
  },
  {
    content: "What improvements would you like to see in our product/service?",
    question_type: "long_text",
    position: 5,
    required: false,
    role_ids: [customer.id]
  },
  {
    content: "How long have you been using our product/service?",
    question_type: "multiple_choice",
    position: 6,
    required: true,
    options: ["Less than a month", "1-6 months", "6-12 months", "1-2 years", "More than 2 years"],
    role_ids: [customer.id]
  },
  {
    content: "What problems does our product/service solve for you?",
    question_type: "long_text",
    position: 7,
    required: false,
    role_ids: [customer.id]
  },
  {
    content: "Which alternative products/services did you consider?",
    question_type: "checkbox",
    position: 8,
    required: false,
    options: ["Competitor A", "Competitor B", "Competitor C", "Competitor D", "None", "Other"],
    role_ids: [customer.id]
  }
]

customer_questions.each do |question_attrs|
  customer_survey.questions.create!(question_attrs)
end

puts "Seed data created successfully!"
