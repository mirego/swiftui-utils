import SwiftUI

extension EnvironmentValues {
    @Entry var htmlForegroundColor: SwiftUI.Color = .black
    @Entry var htmlLineLimit: Int?
    @Entry var htmlKerning: CGFloat = 0
    @Entry var htmlFont: HTMLFont = .system
    @Entry var htmlLineSpacing: CGFloat?
    @Entry var htmlLineBreakMode: NSLineBreakMode = .byTruncatingTail
    @Entry var htmlAccessibilityTraits: UIAccessibilityTraits = .staticText
    @Entry var htmlTextAlignment: NSTextAlignment = .natural
}

extension View {

    public func htmlForegroundColor(_ color: SwiftUI.Color) -> some View {
        environment(\.htmlForegroundColor, color)
    }

    public func htmlLineLimit(_ limit: Int?) -> some View {
        environment(\.htmlLineLimit, limit)
    }

    public func htmlKerning(_ kerning: CGFloat) -> some View {
        environment(\.htmlKerning, kerning)
    }

    public func htmlFont(_ font: HTMLFont) -> some View {
        environment(\.htmlFont, font)
    }

    public func htmlLineSpacing(_ spacing: CGFloat?) -> some View {
        environment(\.htmlLineSpacing, spacing)
    }

    public func htmlLineBreakMode(_ mode: NSLineBreakMode) -> some View {
        environment(\.htmlLineBreakMode, mode)
    }

    public func htmlAccessibilityTraits(_ traits: UIAccessibilityTraits) -> some View {
        environment(\.htmlAccessibilityTraits, traits)
    }

    public func htmlTextAlignment(_ textAlignment: NSTextAlignment) -> some View {
        environment(\.htmlTextAlignment, textAlignment)
    }
}
