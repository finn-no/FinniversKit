// MARK: - ViewModelCoordinator + Extension

extension ViewModelCoordinator {
    public func eraseToAnyCoordinator() -> AnyViewModelCoordinator<Route> {
        return .init(coordinator: self)
    }
}

// MARK: - AnyViewModelCoordinator

public final class AnyViewModelCoordinator<Route>: ViewModelCoordinator {

    // MARK: - Properties

    internal let _handle: (Route) -> ()

    // MARK: - Init

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType) where CoordinatorType.Route == Route {
        _handle = { route in coordinator.handle(route: route) }
    }

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType,
                                                       transform: @escaping (Route) -> CoordinatorType.Route) {
        _handle = { coordinator.handle(route: transform($0)) }
    }

    // MARK: - Coordinator

    public func handle(route: Route) { _handle(route) }
}
