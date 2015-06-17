# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AutoRun", ->
  [workspaceElement, autoRun] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('auto-run').then((pack) ->
        autoRun = pack.mainModule
      )

    runs ->
      atom.config.set('auto-run.commands', [])
      spyOn(atom.workspace, 'openLicense')

  describe "activate", ->
    it "dispatch command", ->
      atom.config.set('auto-run.commands', ['application:open-license'])
      expect(atom.workspace.openLicense).not.toHaveBeenCalled()
      atom.packages.emitter.emit 'did-activate-initial-packages'
      expect(atom.workspace.openLicense).toHaveBeenCalled()

  describe "provideAutoRun", ->
    beforeEach ->
      atom.config.set('test-package.autoRun', false)

    it "registerCommand", ->
      {registerCommand} = autoRun.provideAutoRun()
      registerCommand({keyPath: 'test-package.autoRun', command: 'test-package:start'})
      expect(atom.config.get('auto-run.commands').length).toBe(0)
      atom.config.set('test-package.autoRun', true)
      expect('test-package:start' in atom.config.get('auto-run.commands')).toBe(true)
      atom.config.set('test-package.autoRun', false)
      expect('test-package:start' in atom.config.get('auto-run.commands')).toBe(false)
