RELOAD_INTERVAL = 500

guessAtDeviceFamilyBasedOnViewDump = (viewHeir)->
    switch viewHeir.accessibilityFrame.size.height
      when 1024 then 'ipad'
      when 480 then 'iphone'
      else
        console.warn( "couldn't recognize device family based on screen height of " + data.accessibilityFrame.size.height + "px" )
        'unknown'

define ['frank'],(frank)->

  createController = ({
    tabsController,
    toastController,
    treeView,
    ersatzView,
    detailsView,
    accessibleViewsView,
    experimentBarModel,
    $asplodeButton,
    $reloadButton,
    $liveButton})->

    treeView.model.on 'active-view-changed', (viewModel)->

    treeView.model.on 'selected-view-changed', (viewModel)->
      detailsView.updateModel(viewModel)
      tabsController.selectViewDetailsTab()

    treeView.model.on 'accessible-view-selected', (viewModel)->
      viewModel.setActive()
      experimentBarModel.set( selector: viewModel.getShelleySelector() )


    reportActionOutcome = (action,numViews)->
      message = switch numViews
        when 0 then "Sorry, no views matched that selector so none were #{action}"
        when 1 then "1 view was #{action}"
        else "#{numViews} views were #{action}"
      toastController.showToastMessage(message)

    validateViewSelector = (selector)->
      if selector.length == 0
        toastController.showToastMessage("You haven't provided a view selector. Please enter one below.")
        false
      else
        true


    experimentBarModel.on 'flash-clicked', (model)->
      [selector, selectorEngine] = [model.get('selector'), model.get('selectorEngine')]
      return unless validateViewSelector(selector)
      frank.sendFlashCommand( 
        selector,
        selectorEngine
      ).done (data)->
        reportActionOutcome( "flashed", data.length )

    experimentBarModel.on 'touch-clicked', (model)->
      [selector, selectorEngine] = [model.get('selector'), model.get('selectorEngine')]
      return unless validateViewSelector(selector)

      views = frank.sendTouchCommand( 
        selector,
        selectorEngine
      ).done (data)->
        reportActionOutcome( "touched", data.length )

    experimentBarModel.on 'highlight-clicked', (model)->
      [selector, selectorEngine] = [model.get('selector'), model.get('selectorEngine')]
      return unless validateViewSelector(selector)

      views = frank.getAccessibilityFramesForViewsMatchingSelector( 
        selector,
        selectorEngine
      ).done (data)->
        ersatzView.model.highlightSomeFramesForABit( data )
        reportActionOutcome( "highlighted", data.length )

    $asplodeButton.on 'click', ->
      isAsploded = ersatzView.model.toggleAsploded()
      $asplodeButton.toggleClass( 'down', isAsploded )

    $reloadButton.on 'click', ->
      reload().done ->
        toastController.showToastMessage('views reloaded')

    liveTimeout = undefined
    reloadLoop = ->
      reload()
      liveTimeout = window.setTimeout( reloadLoop, RELOAD_INTERVAL )

    $liveButton.on 'click', ->
      window.clearTimeout(liveTimeout) if liveTimeout?

      if $liveButton.hasClass('down')
        toastController.showToastMessage('leaving live mode')
        $liveButton.removeClass('down')
      else
        reloadLoop()
        toastController.showToastMessage('entering live mode')
        $liveButton.addClass('down')
        
    reload = ->
      deferable = $.Deferred()
      $.when( frank.fetchViewHeirarchy(), frank.fetchOrientation() ).done( ([rawHeir,],orientation)->
        deviceFamily = guessAtDeviceFamilyBasedOnViewDump(rawHeir)

        treeView.model.resetViewHeir(rawHeir)
        ersatzView.model.resetViews(treeView.model.get('allViews'),deviceFamily,orientation)

        accessibleViews = treeView.model.getAccessibleViews()
        accessibleViewsView.collection.reset( accessibleViews )

        ersatzView.render()
        deferable.resolve()
      ).fail( (args...)->
        toastController.showToastMessage('encountered an error while talking to Frank')
        window.alert( "Ruh roh. Encountered an error while talking to Frank.\nSee the javascript console for all the details" )
        console.log( "Failed while talking to Frank.", args ) 
      )

      deferable.promise()

    boot = ->
      tabsController.selectLocatorTab()
      reload()

    {
      boot: boot
    }

  createController
