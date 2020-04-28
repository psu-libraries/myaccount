import { allChecked, pendingHoldsForm, responseFromRails, spinner, submitterValue } from './shared'
import { renderData } from './polling'

const activeHoldsForm = document.querySelector('form#active-holds');

const updateCancelledHold = function (data) {
    document.querySelector(`#hold${data.hold_id} .hold_status`).innerHTML = "<p class='text-danger'>Cancelled</p>";
};

let listenSubmit = (form) => {
    form.addEventListener("submit", function (event) {
        if (submitterValue(event) === "Cancel") {
            allChecked(form).forEach((checkbox) => {
                document.querySelector(`#hold${checkbox.value} .hold_status`).innerHTML = spinner;
            });
        }
    });
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
    if (pendingHoldsForm) {
        listenSubmit(pendingHoldsForm);
        listenAjaxSuccess(pendingHoldsForm);
    }
    if (activeHoldsForm) {
        listenSubmit(activeHoldsForm);
        listenAjaxSuccess(activeHoldsForm);
    }
};

export default cancelHold;