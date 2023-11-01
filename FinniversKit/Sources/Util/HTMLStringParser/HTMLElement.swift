import Foundation

public struct HTMLElement: Hashable {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }
}

extension HTMLElement: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }

    public static func == (lhs: String, rhs: Self) -> Bool {
        return lhs.lowercased() == rhs.name.lowercased()
    }

    public static func == (lhs: Self, rhs: String) -> Bool {
        return lhs.name.lowercased() == rhs.lowercased()
    }
}

extension HTMLElement {
    // swiftlint:disable identifier_name
    public static var b: Self { .init("b") }
    public static var del: Self { .init("del") }
    public static var i: Self { .init("i") }
    public static var s: Self { .init("s") }
    public static var span: Self { .init("span") }
    public static var strong: Self { .init("strong") }
    public static var u: Self { .init("u") }
    // swiftlint:enable identifier_name
}
