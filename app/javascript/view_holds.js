import cancelHold from "./submission_handling/cancel_hold";
import changePickupByDate from "./submission_handling/change_pickup_by_date"
import changePickupLibrary from "./submission_handling/change_pickup_library";
import { fetchHTML } from "./submission_handling/shared";
import selectAll from "./select_all";

const holdsContainer = document.querySelector('.load-holds');

const holds = () => {
    if (holdsContainer) {
        fetchHTML('/holds/all').then((allHolds) => {
            holdsContainer.innerHTML = allHolds;
            changePickupLibrary();
            changePickupByDate();
            cancelHold();
            selectAll.start();
        });
    }
};

export default holds;