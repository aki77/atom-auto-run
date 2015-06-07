
module.exports =
  config:
    commands:
      type: 'array'
      default: []
      items:
        type: 'string'

  activate: ->
    subscription = atom.packages.onDidActivateInitialPackages => @run()

  deactivate: ->
    subscription?.dispose()
    subscription = null

  run: ->
    commands = atom.config.get('init-commands.commands')
    return if commands.length < 1
    workspaceElement = atom.views.getView(atom.workspace)
    for command in commands
      atom.commands.dispatch(workspaceElement, command)
