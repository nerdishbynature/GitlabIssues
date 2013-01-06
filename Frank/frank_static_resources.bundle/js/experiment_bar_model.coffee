define ->
  ExperimentBarModel = Backbone.Model.extend
    defaults:
      engines: ['shelley_compat','uiquery']
      selectorEngine: 'shelley_compat'
      selector: ''

    actionClicked: (actionName)->
      @trigger("#{actionName}-clicked",@)

