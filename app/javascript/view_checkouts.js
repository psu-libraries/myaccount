import { fetchHTML } from "./submission_handling/shared";
import renewCheckout from "./submission_handling/renew_checkout";
import selectAll from "./select_all";

const checkoutsContainer = document.querySelector('.load-checkouts');

const checkouts = () => {
    if (checkoutsContainer) {
        fetchHTML('/checkouts/all').then((allCheckouts) => {
            checkoutsContainer.innerHTML = allCheckouts;
            renewCheckout();
            selectAll.start();
        });
    }
};

export default checkouts;