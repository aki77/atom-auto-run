# auto-run package

When Atom finishes loading, it will dispatch.
[![Build Status](https://travis-ci.org/aki77/atom-auto-run.svg)](https://travis-ci.org/aki77/atom-auto-run)

## Settings

* `commands` (default: [])
* `devCommands` (default: [])

[![Gyazo](http://i.gyazo.com/31adbe6b7752f58b80fa72eb1d18bae9.png)](http://gyazo.com/31adbe6b7752f58b80fa72eb1d18bae9)

## API

This package provides a service that you can use in other Atom packages.

Then, in your package's main module, call methods on the service:

```coffee
module.exports =
  config:
    autoRun:
      type: 'boolean'
      default: false
      description: 'Requirement: auto-run package'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'my-package:start': => @start()

  activateConfig: ->
    pack = atom.packages.getActivePackage('auto-run')
    return unless pack

    autoRun = pack.mainModule.provideAutoRun()
    autoRun.registerCommand(
      keyPath: 'my-package.autoRun'
      command: 'my-package:start'
    )
```

`package.json`

```json
{
  "name": "my-package",
  "activationCommands": {
    "atom-workspace": ["my-package:start"]
  }
}
```
