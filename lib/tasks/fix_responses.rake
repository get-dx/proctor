namespace :data do
  desc "Assign survey branches to existing responses"
  task fix_response_branches: :environment do
    puts "Checking existing responses..."
    
    responses_without_branch = Response.where(survey_branch_id: nil)
    puts "Found #{responses_without_branch.count} responses without survey_branch_id"
    
    responses_without_branch.each do |response|
      puts "Response ID: #{response.id}, Survey: #{response.survey.title}, Question: #{response.question.content[0..50]}"
      
      # Find survey branches that contain this question
      survey_branches = response.survey.survey_branches.joins(:branch_questions)
                               .where(branch_questions: { question_id: response.question_id })
      
      if survey_branches.count == 1
        # Only one branch contains this question, assign it
        response.update!(survey_branch: survey_branches.first)
        puts "  -> Assigned to branch: #{survey_branches.first.role.name}"
      elsif survey_branches.count > 1
        # Multiple branches contain this question, we need to make an assumption
        # For now, assign to the first branch (you might want to modify this logic)
        response.update!(survey_branch: survey_branches.first)
        puts "  -> Multiple branches found, assigned to: #{survey_branches.first.role.name}"
      else
        puts "  -> WARNING: No branch found for this question!"
      end
    end
    
    puts "Done! Updated #{responses_without_branch.count} responses"
  end
  
  desc "Show current response statistics"
  task show_response_stats: :environment do
    puts "Response Statistics:"
    puts "Total responses: #{Response.count}"
    puts "Responses with survey_branch: #{Response.where.not(survey_branch_id: nil).count}"
    puts "Responses without survey_branch: #{Response.where(survey_branch_id: nil).count}"
    
    puts "\nBy Survey:"
    Survey.includes(:responses, :survey_branches).each do |survey|
      puts "  #{survey.title}:"
      puts "    Total responses: #{survey.responses.count}"
      survey.survey_branches.includes(:role).each do |branch|
        puts "    #{branch.role.name}: #{survey.responses.where(survey_branch: branch).count} responses"
      end
    end
  end
end