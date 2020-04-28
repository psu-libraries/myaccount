import { allChecked, pendingHoldsForm, responseFromRails, spinner, submitterValue } from './shared'
import { renderData } from './polling'

const defaultSelectIndex = 0;
let pickupChangeSelect = () => document.querySelector('[data="pickup-location"]');

let validatePickupChange = function (data) {
    if (data.new_value_id === pickupChangeSelect().value) {
        return true;
    }

    return false;
};

const updatePickupChange = function (data) {
    document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
};

// This is the public function
let changePickupLibrary = function () {
    // Guard statement
    if (!pendingHoldsForm) {
        return;
    }

    pendingHoldsForm.addEventListener("submit", function () {
        if (submitterValue(event) === "Update Selected Holds" &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(pendingHoldsForm).forEach((checkbox) => {
                document.querySelector(`#hold${checkbox.value} .pickup_at`).innerHTML = spinner;
            });
        }
    });

    pendingHoldsForm.addEventListener("ajax:success", function () {
        if (responseFromRails(event) === 'Update scheduled' &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(pendingHoldsForm).forEach((checkbox) => {
                renderData(`pickup_library_${checkbox.value}`, updatePickupChange, validatePickupChange);
            });
        }
    });
};

export default changePickupLibrary;
