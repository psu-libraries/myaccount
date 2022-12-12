import cancelHold from "./submission_handling/cancel_hold";
import changePickupByDate from "./submission_handling/change_pickup_by_date"
import changePickupLibrary from "./submission_handling/change_pickup_library";
import { renderData } from "./submission_handling/polling";
import selectAll from "./select_all";

const holdsContainer = document.querySelector('.load-holds');
const illHoldsContainer = document.querySelector('.load-ill-holds');

const showHolds = (data) => {
    holdsContainer.innerHTML = data.html;
    changePickupLibrary();
    changePickupByDate();
    cancelHold();
    selectAll.start();
};

const showIllHolds = (data) => {
    illHoldsContainer.innerHTML = data.html;
    cancelHold();
};

const holds = () => {
    if (illHoldsContainer) {
        renderData(`view_ill_holds_${illHoldsContainer.dataset.username}`, showIllHolds);
    }
    if (holdsContainer) {
        renderData(`view_holds_${holdsContainer.dataset.patronKey}`, showHolds);
    }
};

export default holds;