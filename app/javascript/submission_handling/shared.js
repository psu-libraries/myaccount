export let allChecked = () => document.querySelectorAll('form#pending-holds .checkbox:checked');

export const pendingHoldsForm = document.querySelector('form#pending-holds');

export const spinner = `<div class="spinner-border" role="status">
                   <span class="sr-only">Loading...</span>
                 </div>`;
