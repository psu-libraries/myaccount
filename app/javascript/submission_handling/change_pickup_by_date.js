import { allChecked, findForm, responseFromRails, spinner, submitterValue } from './shared'
import { renderData } from './polling'

let pickupByDateInput = () => document.querySelector('#pickup_by_date');

// Checking for value here is basically a sanity check for edge cases where a stale value
// is already present in Redis. In this edge case what will happen is that the Redis value
// will eventually get updated to the "correct" new value.
let validatePickupByDateChange = function (data) {
    return data.new_value === pickupByDateInput().value
};

const updatePickupByDate = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_by`).innerHTML = data.new_value_formatted;
};

// This is the public function
let changePickupByDate = function () {
    // Guard statement
    if (!findForm('pending-holds')) {
        return;
    }

    findForm('pending-holds').addEventListener("submit", function () {
        if (submitterValue(event) === "Update Selected Holds" && pickupByDateInput().value !== '') {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                document.querySelector(`#hold${checkbox.value} .pickup_by`).innerHTML = spinner;
            });
        }
    });

    findForm('pending-holds').addEventListener("ajax:success", function () {
        if (responseFromRails(event) === 'Update scheduled' && pickupByDateInput().value !== '') {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                renderData(`pickup_by_date_${checkbox.value}`, updatePickupByDate, validatePickupByDateChange);
            });
        }
    });
};

export default changePickupByDate;