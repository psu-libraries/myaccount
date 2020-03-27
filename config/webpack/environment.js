const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')

environment.loaders.prepend('erb', erb)
module.exports = environment
const webpack = require('webpack')

// Set nested object prop using path notation
// environment.config.set('resolve.extensions', ['.foo', '.bar'])
// environment.config.set('output.filename', '[name].js')
// Merge custom config
// environment.config.merge(customConfig)

environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        jquery: 'jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default'],
    })
)


environment.loaders.prepend('erb', erb)
module.exports = environment
