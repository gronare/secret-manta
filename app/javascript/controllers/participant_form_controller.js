import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "addButton"]

  connect() {
    this.hideForm()
  }

  show(event) {
    event.preventDefault()
    this.formTarget.classList.remove("hidden")
    this.addButtonTarget.classList.add("hidden")
  }

  cancel(event) {
    event.preventDefault()
    this.hideForm()
    this.formTarget.querySelector("form").reset()
  }

  hideForm() {
    this.formTarget.classList.add("hidden")
    this.addButtonTarget.classList.remove("hidden")
  }
}
