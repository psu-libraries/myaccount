
export const reportError = function (error) {
    // This is stubbed for now.
    return error;
    // This will be caught as an error by ruby's http gem and reported in logs as well.
    // Thinking it'd be good to replace this with real content. Probably not an alert.
    // alert("There was a problem contacting the Libraries' lending services. " +
    //       "Please call 555-555-5555 for help or try again..");
};

const sleep = (milliseconds) => new Promise((resolve) => setTimeout(resolve, milliseconds));

/* eslint-disable max-statements */
let pollFetch = async function(fn, arg, checkFn) {
    return new Promise( async function(resolve, reject) {
        const maxWaitTime = 20000;
        const pollInterval = 1000;
        const endTime = Number(new Date()) + maxWaitTime;
        let result = '';

        try {
            result = await fn(arg);
            /* eslint-disable no-await-in-loop */
            while (checkFn(result) && Number(new Date()) < endTime) {
                await sleep(pollInterval);
                result = await fn(arg);
            }
            /* eslint-enable no-await-in-loop */
        } catch (error) {
            reportError(error);
            reject(error);
        }

        resolve(result);
    });
};
/* eslint-enable max-statements */

const getJobInfo = function (jobId) {
    return new Promise( async function(resolve, reject) {
        try {
            let response = await fetch(`/redis_jobs/${jobId}`);
            resolve(await response.json());
        } catch(err) {
            reject(err)
        }
    });
};

const deleteData = function (jobId) {
    fetch(`/redis_jobs/${jobId}`, { "method": "delete" });
};

export const renderData = async function (target, checkResults, resultCallback) {
    const result = await pollFetch(getJobInfo, target, checkResults);
    resultCallback(result);
    deleteData(target);
};
