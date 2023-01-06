import { renderData } from "./submission_handling/polling";
import renewCheckout from "./submission_handling/renew_checkout";
import selectAll from "./select_all";

const checkoutsContainer = document.querySelector('.load-checkouts');
const illCheckoutsContainer = document.querySelector('.load-ill-checkouts');

const showCheckouts = (data) => {
    checkoutsContainer.innerHTML = data.html;
    renewCheckout();
    selectAll.start();
};

const showIllCheckouts = (data) => {
    illCheckoutsContainer.innerHTML = data.html;
};

const checkouts = () => {
    if (illCheckoutsContainer) {
        renderData(`view_ill_checkouts_${illCheckoutsContainer.dataset.username}`, showIllCheckouts);
    }
    if (checkoutsContainer) {
        renderData(`view_checkouts_${checkoutsContainer.dataset.patronKey}`, showCheckouts);
    }
};

export default checkouts;