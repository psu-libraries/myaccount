import { allChecked, findForm, responseFromRails, scrollToTop, submitterValue, toggleSpin } from './shared'
import { renderData } from './polling'

const updateCancelledHold = function (data) {
    if (data.result === 'failure') {
        toggleSpin('hold', data.id, 'hold_status');
    } else {
        document.querySelector(`#hold${data.id} .bibitem`).
            innerHTML += data.badge;
        document.querySelector(`#hold${data.id} .hold_status`).innerHTML = data.response;
    }
};

let listenSubmit = (form) => {
    form.addEventListener("submit", function (event) {
        if (submitterValue(event) === "Cancel") {
            allChecked(form).forEach((checkbox) => {
                toggleSpin('hold', checkbox.value, 'hold_status');
            });
        }
    });
    scrollToTop();
};

let listenAjaxSuccess = (form) => {
    form.addEventListener("ajax:success", function (event) {
        if (responseFromRails(event) === 'Deletion scheduled') {
            allChecked(form).forEach((checkbox) => {
                renderData(`cancel_hold_${checkbox.value}`, updateCancelledHold);
            });
        }
    });
};

// This is the public function
let cancelHold = function () {
    // Guard statement
    if (findForm('pending-holds')) {
        listenSubmit(findForm('pending-holds'));
        listenAjaxSuccess(findForm('pending-holds'));
    }
    if (findForm('active-holds')) {
        listenSubmit(findForm('active-holds'));
        listenAjaxSuccess(findForm('active-holds'));
    }
};

export default cancelHold;