import { allChecked, findForm, responseFromRails, toggleSpin } from './shared'
import { renderData } from './polling'

const updateCheckout = function (data) {
    if (data.result === 'failure') {
        toggleSpin('checkout', data.id, 'renewal_count');
        toggleSpin('checkout', data.id, 'due-date');
        toggleSpin('checkout', data.id, 'status');
    } else {
        document.querySelector(`[id="checkout${data.id}"] .renewal_count`).innerHTML = data.response.renewal_count;
        document.querySelector(`[id="checkout${data.id}"] .due-date`).innerHTML = data.response.due_date;
        document.querySelector(`[id="checkout${data.id}"] .status`).innerHTML = data.response.status;
    }
};


// This is the public method
let renewCheckout = function () {
    // Guard statement
    if (!findForm('checkouts')) {
        return;
    }

    findForm('checkouts').addEventListener("submit", function () {
            allChecked(findForm('checkouts')).forEach((checkbox) => {
                toggleSpin('checkout', checkbox.value, 'renewal_count');
                toggleSpin('checkout', checkbox.value, 'due-date');
                toggleSpin('checkout', checkbox.value, 'status');
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
