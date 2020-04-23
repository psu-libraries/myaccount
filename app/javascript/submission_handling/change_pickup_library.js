// This file is basically a class

import { renderData, reportError } from './polling'
import each from 'lodash/map'

// Attributes
const pendingHoldsForm = document.querySelector('form#pending-holds');
const pendingHoldsFormCheckboxes = document.querySelectorAll('form#pending-holds .checkbox');
const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;
const pickupChangeSelect = document.querySelector('[data="pickup-location"]');

let validatePickupChange = function (data) {
    const chosenLocation = pickupChangeSelect.value;
    if (data) {
        if (data.result === "failure") {
            reportError();

            return false;
        } else if (data.result === "success" && data.new_value_id === chosenLocation) {
            return false;
        }
    }

    return true;
}

const updatePickupChange = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
}

// This is the public method
let changePickupLibrary = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (pickupChangeSelect.selectedIndex !== 0 && checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            }
        });
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (checkbox.checked) {
                renderData(checkbox.value, validatePickupChange, updatePickupChange);
            }
        });
    });
}


export default changePickupLibrary;
