public enum HTMLStyler {
    public typealias StyleMap = [StyleKey: UIColor]
}

public extension HTMLStyler {
    struct StyleKey: RawRepresentable, Hashable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String
    }
}

public extension HTMLStyler.StyleKey {
    static let textColor = HTMLStyler.StyleKey("text-color")
}
