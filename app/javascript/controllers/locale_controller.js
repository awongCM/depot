import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const submit = this.element.querySelector('input[type="submit"]')
    if (submit) submit.hidden = true
  }

  submit() {
    this.element.requestSubmit()
  }
}
