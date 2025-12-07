import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["modal", "backdrop", "frame"]

  connect() {
    console.log("Dialog controller connected")
    this.hide() // ensure hidden at start
  }

  open(event) {
    event?.preventDefault()
    console.log("Opening modal")

    // Load turbo frame if specified
    const src = event.currentTarget.dataset.dialogTurboSrc
    if (src && this.hasFrameTarget) {
      this.frameTarget.src = src
    }

    this.show()
  }

  close(event) {
    event?.preventDefault()
    this.hide()
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) this.hide()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") this.hide()
  }

  show() {
    if (this.hasModalTarget && this.hasBackdropTarget) {
      this.modalTarget.classList.remove("hidden")
      this.backdropTarget.classList.remove("hidden")
      document.body.classList.add("overflow-hidden")
    }
  }

  hide() {
    if (this.hasModalTarget && this.hasBackdropTarget) {
      this.modalTarget.classList.add("hidden")
      this.backdropTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }
  }
}

