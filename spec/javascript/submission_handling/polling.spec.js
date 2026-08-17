import { renderData } from "submission_handling/polling";

describe('renderData', () => {
    const JOB_ID = 'job_1';
    const RETRY_DELAY_MS = 1000;

    beforeEach(() => {
        jest.useFakeTimers();
        window.fetch = jest.fn();
    });

    afterEach(() => {
        jest.useRealTimers();
        jest.resetAllMocks();
    });

    it('retries polling after a transient network error', async () => {
        const resultCallback = jest.fn();
        window.fetch.mockRejectedValueOnce(new Error('disconnected'));
        window.fetch.mockResolvedValueOnce({
            "json": () => Promise.resolve({
                "result": 'success',
                "id": JOB_ID
            })
        });
        window.fetch.mockResolvedValueOnce({
            "json": () => Promise.resolve({
                "result": 'deleted'
            })
        });

        renderData(JOB_ID, resultCallback);
        await jest.advanceTimersByTimeAsync(RETRY_DELAY_MS);

        expect(resultCallback).toHaveBeenCalledWith({
            "result": 'success',
            "id": JOB_ID
        });
    });
});
