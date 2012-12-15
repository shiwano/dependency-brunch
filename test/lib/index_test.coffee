helper = require '../test_helper'
fs = require 'fs'

Plugin = helper.require 'index'

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

  describe '#constructor', ->
    it 'should set config which was extracted from brunch config', ->
      expect(plugin.dependencyConfig).to.be.eql
        'string.js': 'nyan.txt'
        'regexp.css': /^test(\/|\\)nyancat/
        'array.html': [
          /^test(\/|\\)wandog/
        ]

  describe '#lint', ->
    beforeEach ->
      sinon.stub plugin, 'updateTimeStampOf'

    it 'should call #updateTimeStampOf when taken path matched specified String', (done) ->
      plugin.lint null, 'nyan.txt', (error) ->
        expect(plugin.updateTimeStampOf.calledOnce).to.be.true
        expect(plugin.updateTimeStampOf.args[0]).to.be.eql ['string.js']
        done()

    it 'should call #updateTimeStampOf when taken path matched specified RegExp', (done) ->
      plugin.lint null, 'test/nyancat/nyan.txt', (error) ->
        expect(plugin.updateTimeStampOf.calledOnce).to.be.true
        expect(plugin.updateTimeStampOf.args[0]).to.be.eql ['regexp.css']
        done()

    it 'should call #updateTimeStampOf when taken path matched specified Array', (done) ->
      plugin.lint null, 'test/wandog/wan.txt', (error) ->
        expect(plugin.updateTimeStampOf.calledOnce).to.be.true
        expect(plugin.updateTimeStampOf.args[0]).to.be.eql ['array.html']
        done()

  describe '#updateTimeStampOf', ->
    it 'update time stamp of specified file', ->
      targetPath = 'test/fixtures/nyan.txt'
      beforeMTime = fs.statSync(targetPath).mtime
      plugin.updateTimeStampOf targetPath
      afterMTime = fs.statSync(targetPath).mtime
      expect(beforeMTime isnt afterMTime).to.be.true
