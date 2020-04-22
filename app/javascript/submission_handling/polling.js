import 'jquery' // Only needed for reportError
import 'bootstrap' // Only needed for reportError

export const reportError = async function (error, arg) {
    document.querySelector(`#hold${arg} .pickup_at`).innerHTML = '<p class="text-danger"><strong>ERROR</strong></p>';
    const item = document.querySelector(`#hold${arg} a`).text;
    const toast =
        `<div class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-autohide="false">
          <div class="toast-header bg-danger text-white">
            <strong class="mr-auto">Error</strong>
            <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="toast-body">
            <p>Something went wrong and "${item}", pickup location was not updated. Contact your campus library if you need assistance.</p>
          </div>
        </div>`;
    await document.querySelector('.toast-insertion-point').insertAdjacentHTML("beforeend", toast);

    $('.toast').toast('show');
};

export const getJobInfo = async (jobId) => {
    let response = await fetch(`/redis_jobs/${jobId}`);

    return response.json();
};

// This would be one million times more elegant in ruby
const validateResult = (data, otherRule) => {
    if (data) {
        if (data.result !== 'not_found') {
            if (otherRule !== null) {
                return otherRule(data);
            }

            return true;
        }
    }

    return false;
};

const pollFetch = function(arg, otherRule = null) {
    const maxWaitTime = 60000;
    const pollInterval = 1000;
    const endTime = Number(new Date()) + maxWaitTime;

    let checkCondition = function(resolve, reject) {
        getJobInfo(arg).then((data) => {
            if (validateResult(data, otherRule)) {
                resolve(data);
            } else if (Number(new Date()) < endTime) {
                setTimeout(checkCondition, pollInterval, resolve, reject);
            } else {
                reject(new Error(`timed out for ${getJobInfo} `));
            }
        }).
        catch((error) => {
            // This would be a network error
            reportError(error);
        });
    };

    return new Promise(checkCondition);
};

const deleteData = function (jobId) {
    fetch(`/redis_jobs/${jobId}`, { "method": "delete" });
};

export const renderData = (target, resultCallback, otherRule = null) => {
    pollFetch(target, otherRule).then((result) => {
        resultCallback(result);
        deleteData(target);
    }).
    catch((error) => {
        // This would be a network error
        reportError(error);
    });
};
