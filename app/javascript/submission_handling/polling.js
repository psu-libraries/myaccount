
export const reportError = function (error) {
    // This is stubbed for now.
    return error;
    // This will be caught as an error by ruby's http gem and reported in logs as well.
    // Thinking it'd be good to replace this with real content. Probably not an alert.
    // alert("There was a problem contacting the Libraries' lending services. " +
    //       "Please call 555-555-5555 for help or try again..");
};

export const getJobInfo = async (jobId) => {
    let response = await fetch(`/redis_jobs/${jobId}`);
    let data = await response.json();

    return data;
};

const pollFetch = function(arg, checkFn) {
    const maxWaitTime = 6000;
    const pollInterval = 1000;
    const endTime = Number(new Date()) + maxWaitTime;

    let checkCondition = function(resolve, reject) {
        // If the condition is met, we're done!
        getJobInfo(arg).then((result) => {
            if (checkFn(result)) {
                resolve(result);
            } else if (Number(new Date()) < endTime) {
                setTimeout(checkCondition, pollInterval, resolve, reject);
            } else {
                reject(new Error(`timed out for ${getJobInfo}`));
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

export const renderData = (target, checkResults, resultCallback) => {
    pollFetch(target, checkResults).then((result) => {
        resultCallback(result);
        deleteData(target);
    }).
    catch((error) => {
        // This would be a network error
        reportError(error);
    });
};
