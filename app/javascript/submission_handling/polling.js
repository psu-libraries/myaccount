// jquery and bootrsap are only needed for reportError
import 'jquery'
import 'bootstrap'

export const reportError = async function (error) {
    const regex = /id="(?<id>[^"]*)/gm;
    let idResults = regex.exec(error);
    await document.querySelector('.toast-insertion-point').insertAdjacentHTML("beforeend", error);
    $(`#${idResults.groups.id}`).toast('show');
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

const checkError = (data) => data.result === 'failure';

const pollFetch = function(arg, otherRule = null) {
    const maxWaitTime = 60000;
    const pollInterval = 1000;
    const endTime = Number(new Date()) + maxWaitTime;

    let checkCondition = function(resolve, reject) {
        getJobInfo(arg).then((data) => {
            if (validateResult(data, otherRule)) {
                resolve(data);
            } else if (checkError(data)) {
                resolve(data);
            } else if (Number(new Date()) < endTime) {
                setTimeout(checkCondition, pollInterval, resolve, reject);
            } else {
                reject(new Error(`timed out for ${getJobInfo} `));
            }
        }).
        catch((error) => {
            // This would be a network error
            // @todo: create a logging service
            // eslint-disable-next-line no-console
            console.error(error);
        });
    };

    return new Promise(checkCondition);
};

const deleteData = function (jobId) {
    fetch(`/redis_jobs/${jobId}`, { "method": "delete" });
};

export const renderData = (target, resultCallback, otherRule = null) => {
    pollFetch(target, otherRule).then((result) => {
        if (checkError(result)) {
            reportError(result.display_error, result.id);
        }

        resultCallback(result);
        deleteData(target);
    }).
    catch((error) => {
        let genericError = { "new_value_formatted": "Error",
                             "id": target };
        resultCallback(genericError);
        reportError('There was a network error, please try again later or call your campus library.', target);
        // The max wait time was reached. Web Service is probably down.
        // @todo: create a logging service
        // eslint-disable-next-line no-console
        console.error(error);
        deleteData(target);
    });
};
