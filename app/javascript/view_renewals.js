import renewal from "./submission_handling/renewal";
//import { renderData } from "./submission_handling/polling";

// const RenewalsContainer = document.querySelector('.load-renewals');
// let { patronKey } = RenewalsContainer.dataset;
//
// const showRenewals = (data) => {
//     RenewalsContainer.innerHTML = data.html;
//     renewal();
// };

const renewals = () => {
    // if (RenewalsContainer) {
    //     renderData(`view_renewals_${patronKey}`, showRenewals);
    // }
    renewal();
};

export default renewals;