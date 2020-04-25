// This file is basically a class

import { renderData, reportError } from './polling'
import each from 'lodash/each'
import moment from 'moment'

// Attributes
const pendingHoldsForm = document.querySelector('form#pending-holds');
const pendingHoldsFormCheckboxes = document.querySelectorAll('form#pending-holds .checkbox');
const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;
const pickupByDateInput = document.querySelector('#pickup_by_date');

let validatePickupByDateChange = function (data) {
    if (data) {
        if (data.result === "failure") {
            reportError();

            return false;
        } else if (data.result === "success" && data.new_value === pickupByDateInput.value) {
            // Checking for value here is basically a sanity check for edge cases where a stale value
            // is already present in Redis. In this edge case what will happen is that the Redis value
            // will eventually get updated to the "correct" new value.
            return false;
        }
    }

    return true;
};

const updatePickupByDate = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_by`).innerHTML = moment(data.new_value).format("MMMM D, YYYY");
};

// This is the public method
let changePickupByDate = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (pickupByDateInput.value !== '' && checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_by`).innerHTML = spinner;
            }
        });
    });
    pendingHoldsForm.addEventListener("ajax:success", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            renderData(`pickup_by_date_${checkbox.value}`, validatePickupByDateChange, updatePickupByDate);
        });
    });
};

export default changePickupByDate;