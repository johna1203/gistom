GistomView = require './gistom-view'

module.exports =
  gistomView: null,
  configDefaults:
    token : ""
    user : ""

  activate: (state) ->
    @gistomView = new GistomView(state.gistomViewState)

  deactivate: ->
    @gistomView.destroy()

  serialize: ->
    gistomViewState: @gistomView.serialize()
