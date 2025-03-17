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
    position: 1
  },
  {
    content: "What programming languages do you use regularly?",
    question_type: "checkbox",
    position: 2
  },
  {
    content: "How many years of experience do you have in software development?",
    question_type: "multiple_choice",
    position: 3
  },
  {
    content: "What tools or resources would help you be more productive?",
    question_type: "text",
    position: 4
  },
  {
    content: "How satisfied are you with the current code review process?",
    question_type: "rating",
    position: 5
  },
  {
    content: "What aspects of our technical stack do you find most challenging?",
    question_type: "text",
    position: 6
  },
  {
    content: "How would you rate the quality of our documentation?",
    question_type: "rating",
    position: 7
  },
  {
    content: "What would you like to see improved in our engineering culture?",
    question_type: "text",
    position: 8
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
    position: 1
  },
  {
    content: "What aspects of the project went well?",
    question_type: "text",
    position: 2
  },
  {
    content: "What challenges did you face during the project?",
    question_type: "text",
    position: 3
  },
  {
    content: "How effective was the communication within the team?",
    question_type: "rating",
    position: 4
  },
  {
    content: "What tools or processes helped you the most during this project?",
    question_type: "text",
    position: 5
  },
  {
    content: "What would you do differently next time?",
    question_type: "text",
    position: 6
  }
]

retro_questions.each do |question_attrs|
  retrospective_survey.questions.create!(question_attrs)
end

puts "Seed data created successfully!"
