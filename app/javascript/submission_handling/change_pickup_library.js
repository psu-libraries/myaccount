// This file is basically a class

import { renderData, reportError } from './polling'
import each from 'lodash/each'
import { spinner, pendingHoldsForm, pendingHoldsFormCheckboxes } from './shared'

// Attributes
const pickupChangeSelect = document.querySelector('[data="pickup-location"]');
const defaultSelectIndex = 0;

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
};

const updatePickupChange = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
};

// This is the public method
let changePickupLibrary = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (pickupChangeSelect.selectedIndex !== defaultSelectIndex && checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            }
        });
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (pickupChangeSelect.selectedIndex !== defaultSelectIndex && checkbox.checked) {
                renderData(`pickup_library_${checkbox.value}`, validatePickupChange, updatePickupChange);
            }
        });
    });
};

export default changePickupLibrary;
