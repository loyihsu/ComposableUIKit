# ComposableUIKit

A simple Composable Architecture extension kit for UIKit.

To create a `UIViewController`:

```swift
class YourViewController: ComposableViewController<YourState, YourAction> {
    // ...
}
```

`ComposableUIKit` hides away all the internal composible architecture subscription details from you.

To send an action, use the class helper to add the action directly to the button:

```swift
class YourViewController: ComposableViewController<YourState, YourAction> {
    // ...
    private lazy var yourButton: UIButton = {
        let button = UIButton()
        // Your button setup
        addAction(.yourAction, to: button, for: .touchUpInside)
        return button
    }()
    // ...
}
```

An action can also be sent through the `send(_:)` endpoint.

To subscribe to the latest changes from the state, override the `update(to:)` method:

```swift
override func update(to state: YourState) {
    // Update your UI based on the state here.
}
```

To create an instance of your `UIViewController`, you can either create with a `Store` or a `ViewStore`:

```swift
let store = Store<YourState, YourAction>(
    initialState: YourState(),
    reducer: YourReducer()
)
let viewController = YourViewController(store: store)
present(viewController, animated: true)
```

To setup your view, when constructing through this endpoint, you can override the instance method `setupView`. This method would be called during the initialisation process, before store subscription is set up. 

In order to access the current state for uses like providing the current data for `UITableView`, you can use the instance property `state`.

If in any case you are not using the `.init` with a store endpoint, you would need to manually call `setupView` and `setupStore(with:)` method to make it work properly.

```swift
let store = Store<YourState, YourAction>(
    initialState: YourState(),
    reducer: YourReducer()
)
let viewStore = ViewStore(store)
let viewController = YourViewController(viewStore: viewStore)
present(viewController, animated: true)
```

Notice there would be no point creating a `ComposableViewController` with other endpoints than the two mentioned above.
