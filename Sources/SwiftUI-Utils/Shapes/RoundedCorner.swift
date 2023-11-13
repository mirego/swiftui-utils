import SwiftUI

public struct RoundedCorner: InsettableShape {
    private let radius: CGFloat
    private let corners: UIRectCorner

    public init(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }

    public func inset(by amount: CGFloat) -> some InsettableShape {
        self
    }
}
