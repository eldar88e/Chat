import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["header", "item"];

    connect() {
        this.updateActiveItem();
    }

    setActive(event) {
        const value = event.currentTarget.dataset.value;
        this.headerTarget.dataset.value = value;
        this.updateActiveItem();
    }

    updateActiveItem() {
        const headerValue = this.headerTarget.dataset.value;

        this.itemTargets.forEach((item) => {
            if (item.dataset.value === headerValue) {
                item.classList.add("active");
            } else {
                item.classList.remove("active");
            }
        });
    }
}
