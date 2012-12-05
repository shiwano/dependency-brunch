(function() {
  var DependencyCompiler, _;

  _ = require('underscore');

  module.exports = DependencyCompiler = (function() {

    DependencyCompiler.prototype.brunchPlugin = true;

    DependencyCompiler.prototype.type = 'javascript';

    DependencyCompiler.prototype.pattern = /.*/;

    function DependencyCompiler(config) {
      this.config = config;
      null;
    }

    DependencyCompiler.prototype.getDependencies = function(data, path, callback) {
      var dependencies, dependency, filePattern, filePatterns, _i, _len, _ref;
      dependencies = [];
      _ref = this.extractConfig();
      for (dependency in _ref) {
        filePatterns = _ref[dependency];
        if (!_.isArray(filePatterns)) {
          filePatterns = [filePatterns];
        }
        for (_i = 0, _len = filePatterns.length; _i < _len; _i++) {
          filePattern = filePatterns[_i];
          if (_.isRegExp(filePattern) && path.match(filePattern)) {
            dependencies.push(dependency);
          } else if (_.isString(filePattern) && path === filePattern) {
            dependencies.push(dependency);
          }
        }
      }
      return callback(null, dependencies);
    };

    DependencyCompiler.prototype.extractConfig = function() {
      var config, fileType, _i, _len, _ref, _ref1;
      config = {};
      _ref = ['javascripts', 'stylesheets', 'templates'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fileType = _ref[_i];
        if ((_ref1 = this.config.files[fileType]) != null ? _ref1.dependOn : void 0) {
          config = _.extend(config, this.config.files[fileType].dependOn);
        }
      }
      return config;
    };

    return DependencyCompiler;

  })();

}).call(this);
