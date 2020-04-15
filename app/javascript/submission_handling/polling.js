
function wait(ms = 1000) {
    return new Promise((resolve) => {
        console.log(`waiting ${ms} ms...`);
        setTimeout(resolve, ms);
    });
}
async function pollFetch(holdId) {
    let endTime = Number(new Date()) + 20000;

    try {
        let result = await getJobInfo(holdId);
        while (checkResults(result) && Number(new Date()) < endTime) {
            await wait(1000);
            result = await getJobInfo(holdId);
        }

        updateDOM(result);
    } catch {
        console.log("failure");
    }
}

