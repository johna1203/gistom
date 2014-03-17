GistomView = require './gistom-view'

module.exports =
  gistomView: null

  activate: (state) ->
    @gistomView = new GistomView(state.gistomViewState)

  deactivate: ->
    @gistomView.destroy()

  serialize: ->
    gistomViewState: @gistomView.serialize()
