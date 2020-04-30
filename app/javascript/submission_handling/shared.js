export let allChecked = (form) => form.querySelectorAll('.checkbox:checked');
export let submitterValue = (event) => {
    if (event.submitter) {
        return event.submitter.value;
    }

    return 'Not defined';
}

export const findForm = (form) => document.querySelector(`form#${form}`);

export const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;

export let responseFromRails = (event) => {
    // See https://guides.rubyonrails.org/working_with_javascript_in_rails.html#rails-ujs-event-handlers
    const railsResponseIndexNumber = 0;
    if (event.detail) {
        return event.detail[railsResponseIndexNumber];
    }

    return 'Not defined';
};