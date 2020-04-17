// This file is basically a class

import { pollFetch, reportError } from './polling'
import each from 'lodash/map'

// Attributes
const pendingHoldsForm = document.querySelector('form#pending-holds');
const pendingHoldsFormCheckboxes = document.querySelectorAll('form#pending-holds .checkbox');
const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;
const pickupChangeSelect = document.querySelector('[data="pickup-location"]');

const getJobInfo = async function (holdId) {
    let response = await fetch(`/redis_jobs/${holdId}`);

    return response.json();
};

let checkResults = function (data) {
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

let updateDOM = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
}

let deleteData = function (item) {
    fetch(`/redis_jobs/${item}`, { "method": "delete" });
}

let renderData = async function (holdID) {
    const result = await pollFetch(getJobInfo, holdID, checkResults);
    await updateDOM(result);
    await deleteData(holdID);
}


// This is the public method
let submissionHandling = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (checkbox.checked) {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            }
        });
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        each(pendingHoldsFormCheckboxes, function (checkbox) {
            if (checkbox.checked) {
                renderData(checkbox.value);
            }
        });
    });
}


export default submissionHandling;
