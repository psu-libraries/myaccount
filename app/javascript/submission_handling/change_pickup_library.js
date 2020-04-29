import { allChecked, findForm, responseFromRails, spinner, submitterValue } from './shared'
import { renderData } from './polling'

const defaultSelectIndex = 0;
let pickupChangeSelect = () => document.querySelector('[data="pickup-location"]');

let validatePickupChange = function (data) {
    return data.new_value_id === pickupChangeSelect().value;
};

const updatePickupChange = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
};

// This is the public function
let changePickupLibrary = function () {
    // Guard statement
    if (!findForm('pending-holds')) {
        return;
    }

    findForm('pending-holds').addEventListener("submit", function () {
        if (submitterValue(event) === "Update Selected Holds" &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            });
        }
    });

    findForm('pending-holds').addEventListener("ajax:success", function () {
        if (responseFromRails(event) === 'Update scheduled' &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                renderData(`pickup_library_${checkbox.value}`, updatePickupChange, validatePickupChange);
            });
        }
    });
};

export default changePickupLibrary;
