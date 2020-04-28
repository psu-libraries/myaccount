import { allChecked, pendingHoldsForm, responseFromRails, spinner, submitterValue } from './shared'
import { renderData } from './polling'

let pickupByDateInput = () => document.querySelector('#pickup_by_date');

let validatePickupByDateChange = function (data) {
    if (data.new_value === pickupByDateInput().value) {
        // Checking for value here is basically a sanity check for edge cases where a stale value
        // is already present in Redis. In this edge case what will happen is that the Redis value
        // will eventually get updated to the "correct" new value.
        return true;
    }

    return false;
};

const updatePickupByDate = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_by`).innerHTML = data.new_value_formatted;
};

// This is the public function
let changePickupByDate = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        if (submitterValue(event) === "Update Selected Holds" && pickupByDateInput().value !== '') {
            allChecked(pendingHoldsForm).forEach((checkbox) => {
                document.querySelector(`#hold${checkbox.value} .pickup_by`).innerHTML = spinner;
            });
        }
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        if (responseFromRails(event) === 'Update scheduled' && pickupByDateInput().value !== '') {
            allChecked(pendingHoldsForm).forEach((checkbox) => {
                renderData(`pickup_by_date_${checkbox.value}`, updatePickupByDate, validatePickupByDateChange);
            });
        }
    });
};

export default changePickupByDate;