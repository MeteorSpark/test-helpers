TestHelpers = (options) ->
  if not options?
    options = {}

  @options = _.extend
    timeout: 1000
  , options

  @

_.extend TestHelpers.prototype,
  getOnCompleteOnce: (onComplete, test_specific_computations) ->
    if test_specific_computations and not _.isArray test_specific_computations
      test_specific_computations = [test_specific_computations]

    comps = null
    if test_specific_computations?
      comps = []
      for test_specific_computation in test_specific_computations
        comps.push Meteor.autorun test_specific_computation

    _.once (cb) ->
      if cb? and _.isFunction(cb)
        cb()

      if comps?
        for comp in comps
          comp.stop()

      onComplete()

  getOnCompleteOnceOrTimeout: (test, onComplete, test_specific_computation) ->
    onCompleteOnce = @getOnCompleteOnce onComplete, test_specific_computation

    setTimeout =>
      onCompleteOnce =>
        test.fail("Timedout")
    , @options.timeout

    onCompleteOnce

  getOnCompleteOnceOrTimeoutWithUser: (test, onComplete, user, password, test_specific_computation, cb) ->
    Meteor.loginWithPassword user, password, (err) =>
      if (err)
        test.fail("Can't login")
        onComplete()

        return

      onCompleteOnceOrTimeout = @getOnCompleteOnceOrTimeout test, onComplete, test_specific_computation

      onCompleteOnceOrTimeoutWithUser = (cb) ->
        Meteor.logout()

        onCompleteOnceOrTimeout(cb)

      cb(onCompleteOnceOrTimeoutWithUser)
