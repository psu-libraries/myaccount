
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
export const pollFetch = async function(fn, arg, checkFn) {
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
    }

    return result;
};
/* eslint-enable max-statements */

const getJobInfo = async function (jobId) {
    let response = await fetch(`/redis_jobs/${jobId}`);

    return response.json();
};

const deleteData = function (jobId) {
    fetch(`/redis_jobs/${jobId}`, { "method": "delete" });
};

export const renderData = async function (target, checkResults, resultCallback) {
    const result = await pollFetch(getJobInfo, target, checkResults);
    await resultCallback(result);
    await deleteData(target);
};