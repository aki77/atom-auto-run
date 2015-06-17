{CompositeDisposable} = require 'atom'

module.exports =
  config:
    commands:
      order: 1
      type: 'array'
      default: []
      items:
        type: 'string'
    devCommands:
      order: 2
      type: 'array'
      default: []
      description: 'dispatch only in development mode'
      items:
        type: 'string'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(atom.packages.onDidActivateInitialPackages => @run())

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null

  run: ->
    @runCommands(atom.config.get('auto-run.commands'))
    if atom.inDevMode()
      @runCommands(atom.config.get('auto-run.devCommands'))

  runCommands: (commands) ->
    return if commands.length < 1
    workspaceElement = atom.views.getView(atom.workspace)
    for command in commands
      atom.commands.dispatch(workspaceElement, command)

  registerCommand: ({keyPath, command, options}) ->
    options ?= {}
    disposable = atom.config.observe(keyPath, (add) =>
      @updateConfig(command, add, options)
    )
    @subscriptions.add(disposable)
    disposable

  updateConfig: (command, add, options = {}) ->
    {devMode} = options
    devMode ?= false
    keyPath = if devMode then 'auto-run.devCommands' else 'auto-run.commands'
    commands = atom.config.get(keyPath)
    exists = command in commands

    if add
      return if exists
      commands.push(command)
    else
      return unless exists
      commands.splice(commands.indexOf(command), 1)

    atom.config.set(keyPath, commands)

  provideAutoRun: ->
    registerCommand: @registerCommand.bind(this)
