(function() {
  var DependencyCompiler, fs, sinon, _;

  _ = require('underscore');

  fs = require('fs');

  sinon = require('sinon');

  module.exports = DependencyCompiler = (function() {

    DependencyCompiler.prototype.brunchPlugin = true;

    DependencyCompiler.prototype.type = 'javascript';

    DependencyCompiler.prototype.pattern = /^.*$/;

    function DependencyCompiler(config) {
      var fileType, _i, _len, _ref, _ref1;
      this.config = config;
      this.dependencyConfig = {};
      _ref = ['javascripts', 'stylesheets', 'templates'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fileType = _ref[_i];
        if ((_ref1 = this.config.files[fileType]) != null ? _ref1.dependOn : void 0) {
          _.extend(this.dependencyConfig, this.config.files[fileType].dependOn);
        }
      }
    }

    DependencyCompiler.prototype.lint = function(data, path, callback) {
      var error;
      try {
        return this._lint(data, path, callback);
      } catch (err) {
        return error = err.stack;
      } finally {
        callback(error);
      }
    };

    DependencyCompiler.prototype._lint = function(data, path, callback) {
      var dependencyPath, filePattern, filePatterns, _ref, _results;
      _ref = this.dependencyConfig;
      _results = [];
      for (dependencyPath in _ref) {
        filePatterns = _ref[dependencyPath];
        if (!_.isArray(filePatterns)) {
          filePatterns = [filePatterns];
        }
        _results.push((function() {
          var _i, _len, _results1;
          _results1 = [];
          for (_i = 0, _len = filePatterns.length; _i < _len; _i++) {
            filePattern = filePatterns[_i];
            if (_.isRegExp(filePattern) && path.match(filePattern)) {
              _results1.push(this.updateTimeStampOf(dependencyPath));
            } else if (_.isString(filePattern) && path === filePattern) {
              _results1.push(this.updateTimeStampOf(dependencyPath));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    DependencyCompiler.prototype.updateTimeStampOf = function(path) {
      var data;
      data = fs.readFileSync(path, 'utf-8');
      return fs.writeFileSync(path, data);
    };

    return DependencyCompiler;

  })();

}).call(this);
