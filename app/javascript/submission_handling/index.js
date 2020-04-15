// This file is basically a class

import _ from 'lodash'

// Attributes
const forms = document.querySelectorAll('form');
const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;

// This is the public method
function submissionHandling() {
  _.each(forms, function (f) {
      f.addEventListener("ajax:success", function() {
        const checkboxes = document.querySelectorAll("input#hold_list_.checkbox");

        _.each(checkboxes, function (c) {
          if (c.checked) {
            document.querySelector(`#hold${c.value} .pickup_at`).innerHTML = spinner;
            renderData(c.value);
          }
        });
      });
  });
}

async function renderData(holdID) {
  const result = await pollFetch(getJobInfo, 20000, holdID);
  await updateDOM(result);
  await deleteData(holdID);
}

// Poll for up to 20 seconds a given function
async function pollFetch(fn, maxTime = 5000, arg) {
  let endTime = Number(new Date()) + maxTime;

    try {
        let result = await fn(arg);
        while (checkResults(result) && Number(new Date()) < endTime) {
            await wait(1000);
            result = await fn(arg);
        }
        return result;
    } catch {
        // This will be caught as an error by ruby's http gem and reported in logs as well.
        console.alert("There was a problem contacting the Libraries' lending services. Please call 555-555-5555 for help or try again..");
    }
}

function wait(ms = 1000) {
    return new Promise((resolve) => {
        console.log(`waiting ${ms} ms...`);
        setTimeout(resolve, ms);
    });
}

const getJobInfo = async function(holdId) {
  let response = await fetch(`/redis_jobs/${holdId}`);
  return response.json();
};

function checkResults(data) {
  return !(data && data.result === "success" || data.result === "failure")
}

function updateDOM(data) {
  document.querySelector(`#hold${data.hold_id} .pickup_at`).innerHTML = data.new_value;
}

function deleteData(item) {
  fetch(`/redis_jobs/${item}`, { method: "delete" });
}

export default submissionHandling;
