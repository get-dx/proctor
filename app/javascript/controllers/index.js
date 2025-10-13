// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

// Manually import all controllers
import QuestionFormController from "./question_form_controller"

// Register controllers
application.register("question-form", QuestionFormController) 