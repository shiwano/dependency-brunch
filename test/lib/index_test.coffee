spec = require '../spec_helper'

Plugin = spec.require 'index'

describe 'Plugin', ->
  config = plugin = null

  beforeEach ->
    config =
      files:
        javascripts:
          dependOn:
            'string.js': 'nyan.txt'
        stylesheets:
          dependOn:
            'regexp.css': /^test(\/|\\)nyancat/
        templates:
          dependOn:
            'array.html': [
              /^test(\/|\\)wandog/
            ]
    plugin = new Plugin(config)

  describe '#getDependencies', ->
    it 'should return dependencies which matched a specified string', (done) ->
      plugin.getDependencies null, 'nyan.txt', (error, dependencies) ->
        expect(dependencies).to.be.eql(['string.js'])
        done()

    it 'should return dependencies which matched a specified RegExp', (done) ->
      plugin.getDependencies null, 'test/nyancat/nyan.txt', (error, dependencies) ->
        expect(dependencies).to.be.eql(['regexp.css'])
        done()

    it 'should return dependencies which matched a specified Array', (done) ->
      plugin.getDependencies null, 'test/wandog/wan.txt', (error, dependencies) ->
        expect(dependencies).to.be.eql(['array.html'])
        done()

  describe '#extractConfig', ->
    it 'should return the config which was extracted from the brunch config', ->
      config = plugin.extractConfig()
      expect(config).to.be.eql
        'string.js': 'nyan.txt'
        'regexp.css': /^test(\/|\\)nyancat/
        'array.html': [
          /^test(\/|\\)wandog/
        ]
