// This file is basically a class

import { allChecked, pendingHoldsForm, spinner } from './shared'
import { renderData, reportError } from './polling'

// Attributes
const defaultSelectIndex = 0;

let pickupChangeSelect = () => document.querySelector('[data="pickup-location"]');

let validatePickupChange = function (data) {
    const chosenLocation = pickupChangeSelect().value;

    if (data) {
        if (data.result === "failure") {
            reportError(data.response);

            return true;
        } else if (data.result === "success" && data.new_value_id === chosenLocation) {
            return true;
        }

return false;

    }

return false;
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
        allChecked().forEach((checkbox) => {
            if (pickupChangeSelect().selectedIndex !== defaultSelectIndex && checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            }
        });
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        allChecked().forEach((checkbox) => {
            if (pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
                renderData(`pickup_library_${checkbox.value}`, validatePickupChange, updatePickupChange);
            }
        });
    });
};

export default changePickupLibrary;
