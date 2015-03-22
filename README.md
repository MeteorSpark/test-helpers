# meteorspark:test-helpers

A collection of helpers for Meteor TinyTest based unittesting

## QuickStart

**Step 1:** Add `meteorspark:test-helpers` to your `package.js`'s
`Package.OnTest`:

```javascript
Package.onTest(function(api) {
  api.use('meteorspark:test-helpers', ['server', 'client']);
});
```

**Step 2:** Initiate a `TestHelpers` instance:

```javascript
var th = new TestHelpers(options);
```

## Constructor

**th = new TestHelpers([options]) Anywhere**

## Default Options

```javascript
{
    timeout: 1000 // timeout definition ms, time before helpers with timeout
                  // fails with a "timeout" message
}
```

## Methods

**onCompleteOnce = th.getOnCompleteOnce(onComplete[, test\_specific\_computations]) Anywhere**

Use in `Tinytest.addAsync` tests, in tests in which onComplete, that TinyTest
expects to be called only once, might be called more than once.

Returns a callback to be used instead of the provided onComplete. This callback
will call the original onComplete only once and will run an optional callback
provided to it in it's first call.

You can provide a computation or a list of [comuptations](http://docs.meteor.com/#/full/tracker_computation) as the second argument,
in which case the helpers will `stop()` each one of them when its provided
callback is called.

*Arguments:*

onComplete: The original onComplete provided to the test function
`Tinytest.addAsync`.

test\_specific\_computations: a computation or an array of computations to
stop() when the returned callback is called.

*onCompleteOnce Arguments:*

```javascript
onCompleteOnce([cb])
```

cb: an optional function to be called only the first time onCompleteOnce
called.

*Example:*

```javascript
var th = new TestHelpers();

Tinytest.addAsync('Test Example', function (test, onComplete) {
    var session_var, subscription;

    var computations = [
        Tracker.autorun(function () {
            subscription = Session.get(subscription);
        }),
        Tracker.autorun(function () {
            Meteor.subscribe(subscription, function () {
                test.ok();

                onCompleteOnce();
            });
        })
    ];

    onCompleteOnce = th.getOnCompleteOnce(onComplete, computations);

    setTimeout(function () {
        onCompleteOnce(function () {
            // Will be called only if onCompleteOnce called here for the first
            // time        

            test.fail("Timedout");

            onCompleteOnce();
        });
    }, 100);
});
```

**onCompleteOnce = th.getOnCompleteOnceOrTimeout(test, onComplete[, test\_specific\_computations]) Anywhere**

Same as th.getOnCompleteOnce but you need to pass the test object as the first
param.

Will fail automatically if timeout, as defined in the timeout option.

## Credits

Developed by <a href="http://www.meteorspark.com"><img src="http://www.meteorspark.com/logo/logo-github.png" title="MeteorSpark" alt="MeteorSpark"></a> [Professional Meteor Services](http://www.meteorspark.com).

## License

MIT

## Author

[Daniel Chcouri](http://theosp.github.io/)
