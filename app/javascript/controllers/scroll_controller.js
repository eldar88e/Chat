import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        this.element.scrollTop = this.element.scrollHeight;
    }

    scrollToBottom() {
        this.element.scrollTop = this.element.scrollHeight;

        const mainUser = document.querySelector('div.user span').textContent;
        const messages = document.getElementById('messages').children;
        const lastMessage = messages[messages.length - 1];
        const lastUser = lastMessage.querySelector('div.sender').textContent.trim();

        if(lastUser !== mainUser) {
            lastMessage.classList.remove('sent');
        }
    }
}
