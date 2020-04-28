
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

    return response.json();
};

// This would be one million times more elegant in ruby
const validateResult = (data, otherRule) => {
    if (data) {
        if (data.result !== 'not_found') {
            if (typeof otherRule !== "undefined") {
                return otherRule(data)
            }

        return true;
        }
    }

    return false;
};

const pollFetch = function(arg, otherRule = null) {
    const maxWaitTime = 6000;
    const pollInterval = 1000;
    const endTime = Number(new Date()) + maxWaitTime;

    let checkCondition = function(resolve, reject) {
        getJobInfo(arg, otherRule).then((data) => {
            if (validateResult(data)) {
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
