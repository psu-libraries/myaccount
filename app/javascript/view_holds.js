import cancelHold from "./submission_handling/cancel_hold";
import changePickupByDate from "./submission_handling/change_pickup_by_date"
import changePickupLibrary from "./submission_handling/change_pickup_library";
import { renderData } from "./submission_handling/polling";

const holdsContainer = document.querySelector('.load-holds');
let { patronKey } = holdsContainer.dataset;

const showHolds = (data) => {
    holdsContainer.innerHTML = data.html;
    changePickupLibrary();
    changePickupByDate();
    cancelHold();
};

const holds = () => {
    if (holdsContainer) {
        renderData(`view_holds_${patronKey}`, showHolds);
    }
};

export default holds;