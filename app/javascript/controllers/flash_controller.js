import { Controller } from "@hotwired/stimulus"

// Handles flash message dismissal
export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  disconnect() {
    // Clear timeout if element is removed before auto-dismiss
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss(event) {
    if (event) {
      event.stopPropagation()
    }

    // Clear the timeout
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    // Fade out animation
    this.element.style.transition = "opacity 300ms ease-out"
    this.element.style.opacity = "0"

    // Remove from DOM after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
