# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "InitCommands", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('init-commands')

    runs ->
      atom.config.set('init-commands.commands', [])
      spyOn(atom.workspace, 'openLicense')

  describe "activate", ->
    it "dispatch command", ->
      atom.config.set('init-commands.commands', ['application:open-license'])
      expect(atom.workspace.openLicense).not.toHaveBeenCalled()
      atom.packages.emitter.emit 'did-activate-initial-packages'
      expect(atom.workspace.openLicense).toHaveBeenCalled()
