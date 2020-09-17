import { allChecked, findForm, responseFromRails, scrollToTop, toggleResults } from './shared'
import { renderData } from './polling'

const updateCheckout = function (data) {
    if (data.result === 'failure') {
        toggleResults('checkout', data.id, 'renewal_count');
        toggleResults('checkout', data.id, 'due-date', false);
        toggleResults('checkout', data.id, 'status', false);
    } else {
        document.querySelector(`[id="checkout${data.id}"] .bibitem`).
            innerHTML += data.response.badge;
        document.querySelector(`[id="checkout${data.id}"] .renewal_count`).
            innerHTML = `<span>${data.response.renewal_count}</span>`;
        document.querySelector(`[id="checkout${data.id}"] .due-date`).
            innerHTML = `<span>${data.response.due_date}</span>`;
        document.querySelector(`[id="checkout${data.id}"] .status`).
            innerHTML = `<span>${data.response.status}</span>`;
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
                toggleResults('checkout', checkbox.value, 'renewal_count');
                toggleResults('checkout', checkbox.value, 'due-date', false);
                toggleResults('checkout', checkbox.value, 'status', false);
            });
            scrollToTop();
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
