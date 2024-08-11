import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.startTimer();
    }

    startTimer() {
        this.timer = setInterval(() => {
            this.element.remove();
        }, 5000)
    }
}