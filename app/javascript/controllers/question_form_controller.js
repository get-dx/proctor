import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="question-form"
export default class extends Controller {
  static targets = ["optionsField"]

  connect() {
    this.toggleOptionsField()
  }

  toggleOptionsField() {
    const questionTypeSelect = this.element.querySelector('select[name="question[question_type]"]')
    const questionType = questionTypeSelect ? questionTypeSelect.value : null
    
    if (!this.hasOptionsFieldTarget) {
      return
    }
    
    const optionsField = this.optionsFieldTarget
    
    if (['multiple_choice', 'checkbox'].includes(questionType)) {
      optionsField.classList.remove('hidden')
    } else {
      optionsField.classList.add('hidden')
    }
  }
} 