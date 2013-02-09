# dependency-brunch
Adds `dependOn` option to
[brunch](http://brunch.io) config.

## Installation
Add `"dependency-brunch": "x.y.z"` to `package.json` of your brunch app.

Pick a plugin version that corresponds to your minor (y) brunch version.

If you want to use git version of plugin, add
`"dependency-brunch": "git+ssh://git@github.com:shiwano/dependency-brunch.git"`.

## Usage
You can use `dependOn` option in `config.coffee`. Example:

```coffescript
exports.config =
  files:
    javascripts:
      dependOn:
        'app/config.coffeeenv': [
          /^app(\/|\\)controllers/
          /^app(\/|\\)views/
          /^app(\/|\\)models/
        ]
```

Now, when `app/controllers/home.coffee` changed, brunch compile `app/config.coffeeenv` too.

More Examples:

```coffescript
exports.config =
  files:
    stylesheets:
      dependOn:
        'app/styli/foo.styl': 'app/styli/bar.styl'
```

```coffescript
exports.config =
  files:
    templates:
      dependOn:
        'app/templates/foo.hbs': /^app(\/|\\)templates/
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## Release History
 * 2013-02-09   v0.1.1   Replace underscore with lodash
 * 2012-12-16   v0.1.0   First release.

## License
Copyright (c) 2012 Shogo Iwano
Licensed under the MIT license.
