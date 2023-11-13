const { generateWebpackConfig } = require('shakapacker')

const customConfig = {
  resolve: {
    extensions: ['.css', '.scss'],
    alias: {
      jquery: 'jquery/src/jquery'
    }
  }
}

module.exports = generateWebpackConfig(customConfig)
