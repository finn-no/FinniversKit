// MARK: - ViewModelCoordinator + Extension

extension ViewModelCoordinator {
    public func eraseToAnyCoordinator() -> AnyViewModelCoordinator<Route> {
        return .init(coordinator: self)
    }

    public func eraseToAnyCoordinator<TargetRoute>(transform: @escaping (TargetRoute) -> Route) -> AnyViewModelCoordinator<TargetRoute> {
        return .init(coordinator: self, transform: transform)
    }
}

// MARK: - AnyViewModelCoordinator

public final class AnyViewModelCoordinator<Route>: ViewModelCoordinator {

    // MARK: - Properties

    internal let handle: (Route) -> Void

    // MARK: - Init

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType) where CoordinatorType.Route == Route {
        handle = { route in coordinator.handle(route: route) }
    }

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType,
                                                       transform: @escaping (Route) -> CoordinatorType.Route) {
        handle = { coordinator.handle(route: transform($0)) }
    }

    // MARK: - Coordinator

    public func handle(route: Route) { handle(route) }
}
