{$, $$, SelectListView} = require 'atom-space-pen-views'

GitHubApi = require 'github'

module.exports =
class GistomView extends SelectListView


  initialize: (@pane) ->
    super
    @addClass('overlay from-top')
    atom.commands.add 'atom-workspace', "gistom:toggle", => @toggle()

    @github = new GitHubApi(
      version: "3.0.0"
      debug: true
    )

  cancelled: ->
    @hide()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  getFilterKey: ->
    'description'

  toggle: ->

    _token = atom.config.get('gistom.token')
    _user = atom.config.get('gistom.user')

    if !atom.config.get('gistom.token')
      atom.config.set('gistom.token', 'YOUR TOKEN')

    if !atom.config.get('gistom.user')
      atom.config.set('gistom.user', 'YOUR USERNAME')

    if !_token || !_user
      return

    @github.authenticate(
      type: "oauth"
      token: _token
    )

    self = @
    @github.gists.getFromUser({user:_user}, (err, data) ->
      # console.log err
      # console.log data
      self.setItems data
    )

    if @panel?.isVisible()
      @cancel()
    else
      @show()

  hide: ->
    @panel?.hide()

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()

    @focusFilterEditor()


  viewForItem: (item) ->
    item.files.length
    "<li>#{item.description} (#{item.files})</li>"

  confirmed: (item) ->
    @cancel()
    atom.commands.dispatch atom.workspace.getActiveTextEditor(), 'application:new-file'

    for k,v of item.files
      $.get v.raw_url, (data) ->
        atom.workspace.open().then (editor) -> editor.insertText(data)
