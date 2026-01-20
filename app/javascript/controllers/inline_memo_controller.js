// app/javascript/controllers/inline_memo_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "input"]

  edit() {
    this.displayTarget.classList.add("hidden")
    this.inputTarget.classList.remove("hidden")
    this.inputTarget.focus()
  }

  async save() {
    const content = this.inputTarget.value

    await fetch("/home_note", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        home_note: { content }
      })
    })

    this.displayTarget.textContent = content || "タップしてメモを書く"
    this.inputTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }
}
