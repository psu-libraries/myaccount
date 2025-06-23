// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Images
import './images'

// Fonts
import 'typeface-open-sans'
import 'typeface-roboto-slab'

// Application styles
import './styles'

// Vendor
import * as bootstrap from 'bootstrap'
import { Dropdown } from 'bootstrap'
window.bootstrap = bootstrap;

// Application javascript
import acceptLendingPolicy from '../accept_lending_policy'
import checkouts from "../view_checkouts"
import holds from "../view_holds"
import selectAll from "../select_all";
import viewRequestedHolds from "../view_requested_holds"

// Rails stuff
require("@rails/ujs").start()
require("@rails/activestorage").start();

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach((el) => {
        el.dropdownInstance = new Dropdown(el);
    });

    selectAll.start();
    holds();
    checkouts();
    viewRequestedHolds();
    acceptLendingPolicy();
});

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)