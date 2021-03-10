import { allChecked, clearBadges, findForm, responseFromRails, scrollToTop, toggleSpin } from './shared'
import { renderData } from './polling'

const updateCheckout = function (data) {
    if (data.result === 'failure') {
        toggleSpin('checkout', data.id, 'renewal_count');
        document.querySelector(`[id="checkout${data.id}"] .bibitem`).
            innerHTML += data.response.badge;
        document.querySelector(`[id="checkout${data.id}"] .due-date span`).classList.toggle('invisible');
        document.querySelector(`[id="checkout${data.id}"] .status span`).classList.toggle('invisible');
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

const renderProcessing = function () {
    const infoHTML = `<div class="alert alert-info" role="alert">
                        <span>Renewals are in progress...</span>
                      </div>`;

    if (document.querySelector('.myaccount-info')) {
        document.querySelector('.myaccount-info').innerHTML = infoHTML;
    } else {
        let infoElement = document.createElement('div');
        infoElement.classList.add('myaccount-info');
        infoElement.innerHTML = infoHTML;

        document.querySelector('.load-checkouts').prepend(infoElement);
    }
};

const renderSummary = function () {
    if (document.querySelector('.myaccount-info .alert-info')) {
        const successCount = document.querySelectorAll('.bibitem .badge-success').length;
        const failCount = document.querySelectorAll('.bibitem .badge-danger').length;
        const allCheckedCount = allChecked(findForm('checkouts')).length;
        let info = 'Your renewals are processing...';
        if (allCheckedCount === failCount + successCount) {
            info = 'Renewals processing completed.';
        }
        const summary = `${info} <br>
                        ${successCount} successfully renewed <br> 
                        ${failCount} failed to renew`;
        document.querySelector('.myaccount-info .alert-info').
            innerHTML = `<span>${summary}</span>`;
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
                document.querySelector(`[id="checkout${checkbox.value}"] .due-date span`).classList.toggle('invisible');
                document.querySelector(`[id="checkout${checkbox.value}"] .status span`).classList.toggle('invisible');
            });
            renderProcessing();
            scrollToTop();
    });

    findForm('checkouts').addEventListener("ajax:before", function () {
            clearBadges();
    });

    findForm('checkouts').addEventListener("ajax:success", function (event) {
        if (responseFromRails(event) === 'Renew') {
            allChecked(findForm('checkouts')).forEach((checkbox) => {
                renderData(`renewal_${checkbox.value}`, updateCheckout, null, renderSummary);
            });
        }
    });

    findForm('checkouts').addEventListener("ajax:error", function () {
        $('#expiryModal').modal({ "keyboard": false });
    });
};


export default renewCheckout;
