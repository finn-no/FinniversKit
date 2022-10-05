// Inspired by https://github.com/nkristek/Navigation however the `viewController` property is
// removed to help with separation from any UI component.

public protocol ViewModelCoordinator: AnyObject {
    associatedtype Route
    func handle(route: Route)
}
