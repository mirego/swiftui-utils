import SwiftUI

public extension Backport where Content: View {
    @ViewBuilder
    func scrollTargetLayout() -> some View {
        if #available(iOS 17, *) {
            content.scrollTargetLayout()
        } else {
            content
        }
    }

    @ViewBuilder
    func scrollTargetBehaviorResetUnder(offset: CGFloat) -> some View {
        if #available(iOS 17, *) {
            content.scrollTargetBehavior(ResetUnderScrollTargetBehavior(offset: offset))
        } else {
            content
        }
    }
}

@available(iOS 17.0, *)
public struct ResetUnderScrollTargetBehavior: ScrollTargetBehavior {
    public let offset: CGFloat

    public func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < offset {
            target.rect = .zero
        }
    }
}
