fs = require 'fs'
path = require 'path'

global.expect = require('chai').expect
global.sinon = require 'sinon'

exports.require = (path) =>
  require "#{__dirname}/../src/#{path}"
