// This file is basically a class

import { allChecked, pendingHoldsForm, spinner } from './shared'
import { renderData, reportError } from './polling'

// Attributes
let pickupByDateInput = () => document.querySelector('#pickup_by_date');

let validatePickupByDateChange = function (data) {
    if (data) {
        if (data.result === "failure") {
            reportError(data.response);

            return true;
        } else if (data.result === "success" && data.new_value === pickupByDateInput().value) {
            // Checking for value here is basically a sanity check for edge cases where a stale value
            // is already present in Redis. In this edge case what will happen is that the Redis value
            // will eventually get updated to the "correct" new value.
            return true;
        }

    return false;

    }

    return true;
};

const updatePickupByDate = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_by`).innerHTML = data.new_value_formatted;
};

// This is the public method
let changePickupByDate = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        allChecked().forEach((checkbox) => {
            if (pickupByDateInput().value !== '' && checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_by`).innerHTML = spinner;
            }
        });
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        allChecked().forEach((checkbox) => {
            if (pickupByDateInput().value !== '' && checkbox.checked) {
                renderData(`pickup_by_date_${checkbox.value}`, validatePickupByDateChange, updatePickupByDate);
            }
        });
    });
};

export default changePickupByDate;