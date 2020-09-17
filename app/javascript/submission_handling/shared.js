export let allChecked = (form) => form.querySelectorAll('.checkbox:checked');
export let submitterValue = (event) => {
    if (event.submitter) {
        return event.submitter.value;
    }

    return 'Not defined';
};

export const findForm = (form) => document.querySelector(`form#${form}`);

export const spinner = `<div class="spinner-border spinner-border-sm text-secondary" role="status">
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

export const toggleSpin = function (cssPath) {
    if (document.querySelector(`${cssPath} .spinner-border`)) {
        document.querySelector(`${cssPath} .spinner-border`).remove();
    } else {
        document.querySelector(`${cssPath}`).innerHTML += spinner;
        if (document.querySelector(`${cssPath} .warning`)) {
            document.querySelector(`${cssPath} .warning`).remove();
        }
    }
};

// eslint-disable-next-line max-params
export const toggleResults = function (type, key, className, showSpinner = true) {
    const cssPath = `[id="${type}${key}"] .${className}`;
    document.querySelector(`${cssPath} span`).classList.toggle('invisible');
    if (showSpinner) {
        toggleSpin(cssPath)
    }
};

export const scrollToTop = () => {
    window.scroll({
        "top": 0,
        "left": 0,
        "behavior": 'smooth'
    });
};