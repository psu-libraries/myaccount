import { allChecked, clearBadges, findForm, responseFromRails, scrollToTop, submitterValue, toggleSpin } from './shared'
import { renderData } from './polling'

const defaultSelectIndex = 0;
let pickupChangeSelect = () => document.querySelector('[data="pickup-location"]');

let validatePickupChange = function (data) {
    return data.response.new_value_id === pickupChangeSelect().value;
};

const updatePickupChange = function (data) {
    if (data.result === 'failure') {
        toggleSpin('hold', data.id, 'pickup_at');
    } else {
        document.querySelector(`#hold${data.id} .bibitem`).innerHTML += data.response.badge;
        document.querySelector(`#hold${data.id} .pickup_at`).
            innerHTML = `<span>${data.response.new_value}</span>`;
    }
};

// This is the public function
let changePickupLibrary = function () {
    // Guard statement
    if (!findForm('pending-holds')) {
        return;
    }

    findForm('pending-holds').addEventListener("submit", function (event) {
        if (submitterValue(event) === "Update Selected Holds" &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                toggleSpin('hold', checkbox.value, 'pickup_at');
            });
        }
        scrollToTop();
    });

    findForm('pending-holds').addEventListener("ajax:before", function (event) {
        if (submitterValue(event) === "Update Selected Holds" &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            clearBadges();
        }
    });

    findForm('pending-holds').addEventListener("ajax:success", function (event) {
        if (responseFromRails(event) === 'Update scheduled' &&
            pickupChangeSelect().selectedIndex !== defaultSelectIndex) {
            allChecked(findForm('pending-holds')).forEach((checkbox) => {
                renderData(`pickup_library_${checkbox.value}`, updatePickupChange, validatePickupChange);
            });
        }
    });
};

export default changePickupLibrary;
