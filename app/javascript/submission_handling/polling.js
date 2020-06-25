import 'jquery' // Only needed for reportError
import 'bootstrap' // Only needed for reportError

export const reportError = async function (error, arg) {
    const regex = /id\=\"([^\"]*)/gm;
    let id_results = regex.exec(error);
    const capture_group = 1;
    await document.querySelector('.toast-insertion-point').insertAdjacentHTML("beforeend", error);
    $(`#${id_results[capture_group]}`).toast('show');
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

const checkError = (data) => {
    return data.result === 'failure';
};

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
            console.log(error);
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
            reportError(result.response, result.id);
        }

        resultCallback(result);
        deleteData(target);
    }).
    catch((error) => {
        // The max wait time was reached. Web Service is probably down.
        console.log(error);
    });
};
