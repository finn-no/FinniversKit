import Foundation

extension Array where Array.Element: ExpressibleByNilLiteral {
    public subscript(safe index: Index) -> Element {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
