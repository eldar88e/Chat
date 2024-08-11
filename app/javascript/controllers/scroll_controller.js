import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        current: String
    }

    connect() {
        this.scrollToBottom();

        this.observer = new MutationObserver(() => {
            this.scrollToBottom();
            this.findUser();
        });

        this.observer.observe(this.element, {
            childList: true,
            subtree: true
        });
    }

    disconnect() {
        if (this.observer) {
            this.observer.disconnect();
        }
    }

    scrollToBottom() {
        this.element.scrollTop = this.element.scrollHeight;
    }

    findUser() {
        let elements = this.element.querySelectorAll('.message-wrap');
        let lastElement = elements[elements.length - 1];
        let userValue = lastElement.dataset.value;
        if (this.currentValue === userValue) {
            lastElement.classList.add('sent');
        }
        else {
            lastElement.classList.remove('sent');
            lastElement.classList.add('received');
        }
    }
}
