import SwiftUI

extension EnvironmentValues {
    @Entry var htmlForegroundColor: SwiftUI.Color = .black
    @Entry var htmlLineLimit: Int?
    @Entry var htmlKerning: CGFloat = 0
    @Entry var htmlBaseFontSize: CGFloat = 16
    @Entry var htmlFont: HTMLFont = .system
    @Entry var htmlLineSpacing: CGFloat?
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

    public func htmlBaseFontSize(_ size: CGFloat) -> some View {
        environment(\.htmlBaseFontSize, size)
    }

    public func htmlFont(_ font: HTMLFont) -> some View {
        environment(\.htmlFont, font)
    }

    public func htmlLineSpacing(_ spacing: CGFloat?) -> some View {
        environment(\.htmlLineSpacing, spacing)
    }
}
