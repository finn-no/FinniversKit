import SwiftUI

public struct RoundedCorner: InsettableShape {
    public var radius: CGFloat
    public var corners: UIRectCorner

    public var insetAmount = 0.0

    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let path = UIBezierPath(roundedRect: insetRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        var roundedCorner = self
        roundedCorner.insetAmount += amount
        return roundedCorner
    }
}
