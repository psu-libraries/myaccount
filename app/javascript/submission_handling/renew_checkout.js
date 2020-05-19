import { allChecked, findForm, responseFromRails, spinner } from './shared'
import { renderData } from './polling'

const updateCheckout = function (data) {
    document.querySelector(`[id="checkout${data.item_key}"] .renewal_count`).innerHTML = data.renewal_count;
    document.querySelector(`[id="checkout${data.item_key}"] .due_date`).innerHTML = data.due_date;
    document.querySelector(`[id="checkout${data.item_key}"] .status`).innerHTML = data.status;
};

// This is the public method
let renewCheckout = function () {
    // Guard statement
    if (!findForm('checkouts')) {
        return;
    }

    findForm('checkouts').addEventListener("submit", function () {
            allChecked(findForm('checkouts')).forEach((checkbox) => {
                document.querySelector(`[id="checkout${checkbox.value}"] .renewal_count`).innerHTML = spinner;
                document.querySelector(`[id="checkout${checkbox.value}"] .due_date`).innerHTML = spinner;
                document.querySelector(`[id="checkout${checkbox.value}"] .status`).innerHTML = spinner;
            });
    });

    findForm('checkouts').addEventListener("ajax:success", function (event) {
        if (responseFromRails(event) === 'Renew') {
            allChecked(findForm('checkouts')).forEach((checkbox) => {
                renderData(`renewal_${checkbox.value}`, updateCheckout);
            });
        }
    });
};


export default renewCheckout;
