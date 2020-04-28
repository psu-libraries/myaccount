export let allChecked = (form) => form.querySelectorAll('.checkbox:checked');
export let submitterValue = (event) => {
    if (event.submitter) {
        return event.submitter.value;
    }

    return 'Not defined';
}

export const pendingHoldsForm = document.querySelector('form#pending-holds');

export const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;

export let responseFromRails = (event) => {
    if (event.detail) {
        return event.detail[0];
    }

    return 'Not defined';
};