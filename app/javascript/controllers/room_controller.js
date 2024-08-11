import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["output", "list"];

    connect() {
        window.scroles = this.element;
    }

    handler() {
        document.addEventListener("turbo:submit-end", (event) => {
            if (event.detail.success) {
                this.clear();
                this.down();
            }
        });
    }

    clear() {
        this.outputTarget.value = '';
    }

    down() {
        this.listTarget.scrollTop = this.listTarget.scrollHeight;
    }

}
