_ = require 'underscore'

module.exports = class DependencyCompiler
  brunchPlugin: yes
  type: 'javascript'
  pattern: /.*/

  constructor: (@config) ->
    null

  getDependencies: (data, path, callback) ->
    dependencies = []

    for dependency, filePatterns of @extractConfig()
      filePatterns = [filePatterns] unless _.isArray filePatterns

      for filePattern in filePatterns
        if _.isRegExp(filePattern) and path.match(filePattern)
          dependencies.push dependency
        else if _.isString(filePattern) and path is filePattern
          dependencies.push dependency

    callback null, dependencies

  extractConfig: ->
    config = {}

    for fileType in ['javascripts', 'stylesheets', 'templates']
      if @config.files[fileType]?.dependOn
        config = _.extend config, @config.files[fileType].dependOn

    config
