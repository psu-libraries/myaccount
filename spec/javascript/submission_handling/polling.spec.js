import { renderData } from "submission_handling/polling";

describe('renderData', () => {
    beforeEach(() => {
        jest.useFakeTimers();
        global.fetch = jest.fn();
    });

    afterEach(() => {
        jest.useRealTimers();
        jest.resetAllMocks();
    });

    it('retries polling after a transient network error', async () => {
        const resultCallback = jest.fn();
        global.fetch
            .mockRejectedValueOnce(new Error('disconnected'))
            .mockResolvedValueOnce({
                json: async () => ({ result: 'success', id: 'job_1' })
            })
            .mockResolvedValueOnce({
                json: async () => ({ result: 'deleted' })
            });

        renderData('job_1', resultCallback);
        await Promise.resolve();
        jest.advanceTimersByTime(1000);
        await Promise.resolve();
        await Promise.resolve();

        expect(resultCallback).toHaveBeenCalledWith({ result: 'success', id: 'job_1' });
    });
});
