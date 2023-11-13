import SwiftUI

public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLet<Content: View, T>(_ optional: T?, content: (Self, T) -> Content) -> some View {
        switch optional {
        case .some(let value):
            content(self, value)
        default:
            self
        }
    }

    func log(_ value: Any) -> some View {
        #if DEBUG
        print("DEBUG LOG: \(value)")
        #endif
        return self
    }
}
