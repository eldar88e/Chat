import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["output", "list"];

    handler() {
        this.observer = new MutationObserver(() => {
            this.clear();
            this.down();
        });

        this.observer.observe(this.element, {
            childList: true,
            subtree: true
        });
    }

    clear() {
        this.outputTarget.value = '';
    }

    down() {
        this.listTarget.scrollTop = this.listTarget.scrollHeight;
    }

}
