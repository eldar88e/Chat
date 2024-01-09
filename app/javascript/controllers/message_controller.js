import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["output"];

    connect() {
    }

    clear() {
        document.addEventListener("turbo:submit-end", (event) => {
            if (event.detail.success) {
                this.outputTarget.value = '';
            }
        });
    }
}
