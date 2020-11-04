const defaultIndex = 0;

export let allChecked = (form) => form.querySelectorAll('.checkbox:checked');
export let submitterValue = (event) => {
    if (event.submitter) {
        return event.submitter.value;
    }

    return 'Not defined';
};

export const findForm = (form) => document.querySelector(`form#${form}`);

export const spinner = () => {
    const innerSpinnerHTML = `<div class="spinner-border spinner-border-sm text-secondary" role="status">
                                  <span class="sr-only">Loading...</span>
                              </div>`;
    let spinElement = document.createElement('div');
    spinElement.classList.add('myaccount-spinner');
    spinElement.innerHTML = innerSpinnerHTML;

    return spinElement;
};

export let responseFromRails = (event) => {
    // See https://guides.rubyonrails.org/working_with_javascript_in_rails.html#rails-ujs-event-handlers
    const railsResponseIndexNumber = 0;
    if (event.detail) {
        return event.detail[railsResponseIndexNumber];
    }

    return 'Not defined';
};

export const toggleSpin = function (type, key, className) {
    const cssPath = `[id="${type}${key}"] .${className}`;
    document.querySelector(`${cssPath} span`).classList.toggle('invisible');
    if (document.querySelector(`${cssPath} .spinner-border`)) {
        document.querySelector(`${cssPath} .spinner-border`).remove();
    } else {
        document.querySelector(`${cssPath}`).prepend(spinner());
        if (document.querySelector(`${cssPath} .warning`)) {
            document.querySelector(`${cssPath} .warning`).remove();
        }
    }
};

export const scrollToTop = () => {
    window.scroll({
        "top": 0,
        "left": 0,
        "behavior": 'smooth'
    });
};

export const clearBadges = () => {
    const badges = document.getElementsByClassName('badge-success');
    while (badges.length > defaultIndex) {
        badges[defaultIndex].remove();
    }
};

export const fetchHTML = async (url) => {
    // try/catch as a wrapper to the fetch and parse of attempted fetch handles all errors including 404, 500 or
    // general network problems
    try {
        let fetchResponse = await fetch(url).
            then((response) => {
                if (!response.ok) {
                    throw new Error('There was a problem, please try again or contact the Libraries if the problem' +
                        ' persists.');
                }

                return response;
            });

return await fetchResponse.text();
    } catch (err) {
        return err;
    }
};