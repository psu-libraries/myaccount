export const pollFetch = async function(fn, maxTime = 5000, arg, checkFn) {
    let endTime = Number(new Date()) + maxTime;

    try {
        let result = await fn(arg);
        while (checkFn(result) && Number(new Date()) < endTime) {
            await setTimeout(function(){}, 1000);
            result = await fn(arg);
        }
        return result;
    } catch {
        reportError();
    }
}

export const reportError = function() {
    // This will be caught as an error by ruby's http gem and reported in logs as well.
    // Thinking it'd be good to replace this with real content. Probably not an alert.
    alert("There was a problem contacting the Libraries' lending services. Please call 555-555-5555 for help or try again..");
}