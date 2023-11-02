// MARK: - ViewModelCoordinator + Extension

extension ViewModelCoordinator {
    public func eraseToUnownedCoordinator() -> UnownedViewModelCoordinator<Route> {
        return .init(coordinator: self)
    }

    public func eraseToUnownedCoordinator<TargetRoute>(transform: @escaping (TargetRoute) -> Route) -> UnownedViewModelCoordinator<TargetRoute> {
        return .init(coordinator: self, transform: transform)
    }
}

// MARK: - UnownedCoordinator

public final class UnownedViewModelCoordinator<Route>: ViewModelCoordinator {

    // MARK: - Properties

    internal let handle: (Route) -> Void

    // MARK: - Init

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType) where CoordinatorType.Route == Route {
        handle = { [unowned coordinator] route in coordinator.handle(route: route) }
    }

    public init<CoordinatorType: ViewModelCoordinator>(coordinator: CoordinatorType,
                                                       transform: @escaping (Route) -> CoordinatorType.Route) {
        handle = { [unowned coordinator] in coordinator.handle(route: transform($0)) }
    }

    // MARK: - Coordinator

    public func handle(route: Route) { handle(route) }
}
