const { generateWebpackConfig } = require('shakapacker')

const customConfig = {
  resolve: {
    extensions: ['.css', '.scss']
  }
}

module.exports = generateWebpackConfig(customConfig)
