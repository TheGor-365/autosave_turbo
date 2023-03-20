import { Controller } from "@hotwired/stimulus"
import debounce from "lodash.debounce"

// Connects to data-controller="poster"
export default class extends Controller {
  connect() {
    this.form = this.element.closest("form")
    this.formData = new FormData(this.form)
    this.url = this.form.action + "/autosave"
    const autosave_delay = this.form.dataset.autosaveDelay
    this.autosaveDelayAsInt = parseInt(autosave_delay)

    const requestToDelay = () => this.sendRequest(this.url, this.formData)

    this.debouncedRequest = debounce(requestToDelay, this.autosaveDelayAsInt)
  }

  save() {
    this.formData = new FormData(this.form)
    this.debouncedRequest(this.url, this.formData)
  }

  sendRequest(url, formData) {
    console.log("Sending request to " + url)

    fetch(url, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Accept": "text/vnd.turbo-stream.html"
      },
      credentials: "same-origin"
    }).then((response) => {
      response.text().then((html) => {
        document.body.insertAdjacentHTML("beforeend", html)
      })
    })
  }
}
