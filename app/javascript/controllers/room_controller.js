import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["output"];

    clear() {
        document.addEventListener("turbo:submit-end", (event) => {
            if (event.detail.success) {
                this.outputTarget.value = '';
                let listRooms = document.querySelector('div.list-rooms');
                listRooms.scrollTop = listRooms.scrollHeight;
            }
        });
    }
}
