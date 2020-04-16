// This file is basically a class

import each from 'lodash/map'
import {pollFetch, reportError} from './polling'

// Attributes
const pendingHoldsForm = document.querySelector('form#pending-holds');
const pendingHoldsFormCheckboxes = document.querySelectorAll('form#pending-holds .checkbox');
const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;
const pickup_change_select = document.querySelector('[data="pickup-location"]');

// This is the public method
function submissionHandling() {
    // Guard statement
    if (!(pendingHoldsForm)) {
        return;
    }
    pendingHoldsForm.addEventListener("ajax:success", function() {

        each(pendingHoldsFormCheckboxes, function(c) {
            if (c.checked) {
                document.querySelector(`#hold${c.value} .pickup_at`).innerHTML = spinner;
                renderData(c.value);
            }
        });
    });
}

async function renderData(holdID) {
  const result = await pollFetch(getJobInfo, 20000, holdID, checkResults);
  await updateDOM(result);
  await deleteData(holdID);
}

const getJobInfo = async function(holdId) {
  let response = await fetch(`/redis_jobs/${holdId}`);
  return response.json();
};

function checkResults(data) {
  const chosen_location = pickup_change_select.value;
  if (data) {
      if (data.result === "failure") {
          reportError();
          return false;
      } else if (data.result === "success" && data.new_value_id === chosen_location) {
          return false;
      }
  }

  return true;
}

function updateDOM(data) {
  document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
}

function deleteData(item) {
  fetch(`/redis_jobs/${item}`, { method: "delete" });
}

export default submissionHandling;
