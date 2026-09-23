import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  add() {
    const submit = this.element.querySelector("form input[type=submit], form button[type=submit]")
    if (submit) submit.click()
  }
}
