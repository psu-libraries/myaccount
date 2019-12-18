const selectAll = {
    start() {
        const targetKeywords = this.extractCheckboxTargets();
        this.setListeners(targetKeywords);
    },

    setListeners(targetKeywords) {
        targetKeywords.forEach(function(targetKeyword){
            const boxesToSelect = document.querySelectorAll(`input[data-checkbox-type=${targetKeyword}`);
            const controllerCheckbox = document.querySelector(`input[data-select-all=${targetKeyword}]`);
            controllerCheckbox.onclick = function() {
                let checkedStatus = controllerCheckbox.checked;
                boxesToSelect.forEach(function(targetBox) {
                        targetBox.checked = checkedStatus
                });
            }
        });
    },

    extractCheckboxTargets() {
        const checkboxes = document.querySelectorAll("input[data-select-all]");
        const targetKeywords = [];
        checkboxes.forEach(function(el) {
            targetKeywords.push(el.dataset.selectAll);
        });

        return targetKeywords;
    },
}

export default selectAll;
