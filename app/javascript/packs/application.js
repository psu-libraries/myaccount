// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Fonts
import 'typeface-open-sans'
import 'typeface-roboto-slab'

// Vendor
import 'bootstrap/dist/js/bootstrap'
import _ from 'lodash'

// Application styles
import './styles'

// Application javascript
import selectAll from "../select_all";
import submissionHandling from "../submission_handling/index.js.erb"

// Rails stuff
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

document.addEventListener("turbolinks:load", function() {
    selectAll.start();
    submissionHandling();
});


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)