import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question-form"
export default class extends Controller {
  static targets = ["optionsField"]

  connect() {
    this.toggleOptionsField()
  }

  toggleOptionsField() {
    const questionType = document.getElementById('question_question_type').value
    const optionsField = document.getElementById('options-field')
    
    if (['multiple_choice', 'checkbox'].includes(questionType)) {
      optionsField.classList.remove('hidden')
    } else {
      optionsField.classList.add('hidden')
    }
  }
} 