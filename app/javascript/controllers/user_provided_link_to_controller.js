import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit(event) {
    event.preventDefault()

    let action = this.inputTargets.reduce((memo, target) => {
      return memo.replace(target.dataset.replaces, target.value)
    }, this.form.action)

    Turbolinks.visit(action)
  }

  get form() {
    return this.element
  }
}
