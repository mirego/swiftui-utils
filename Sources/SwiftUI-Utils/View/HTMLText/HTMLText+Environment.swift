import SwiftUI

public struct HTMLCacheConfiguration: Equatable {
    let cache: NSCache<NSString, NSAttributedString>?

    public static let `default`: HTMLCacheConfiguration = {
        let cache = NSCache<NSString, NSAttributedString>()
        cache.countLimit = 100
        cache.name = "com.mirego.swiftui-utils.HTMLCache"
        return HTMLCacheConfiguration(cache: cache)
    }()

    public static func custom(_ cache: NSCache<NSString, NSAttributedString>) -> HTMLCacheConfiguration {
        HTMLCacheConfiguration(cache: cache)
    }

    public static var disabled = HTMLCacheConfiguration(cache: nil)

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cache === rhs.cache
    }
}

extension EnvironmentValues {
    @Entry var htmlForegroundColor: SwiftUI.Color = .black
    @Entry var htmlLineLimit: Int?
    @Entry var htmlKerning: CGFloat = 0
    @Entry var htmlFont: HTMLFont = .system
    @Entry var htmlLineSpacing: CGFloat?
    @Entry var htmlLineBreakMode: NSLineBreakMode = .byTruncatingTail
    @Entry var htmlAccessibilityTraits: UIAccessibilityTraits = .staticText
    @Entry var htmlTextAlignment: NSTextAlignment = .natural
    @Entry var htmlOpenURL: HTMLOpenURLAction? = nil
    @Entry var htmlCacheConfiguration: HTMLCacheConfiguration = .default
}

struct HTMLOpenURLAction: Equatable {
    let id = UUID()
    let handler: (URL) -> Void
    
    func callAsFunction(_ url: URL) {
        handler(url)
    }

    static func == (lhs: HTMLOpenURLAction, rhs: HTMLOpenURLAction) -> Bool {
        lhs.id == rhs.id
    }
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
    
    public func onHTMLOpenURL(_ perform: @escaping (URL) -> Void) -> some View {
        environment(\.htmlOpenURL, HTMLOpenURLAction(handler: perform))
    }

    public func htmlCache(_ cache: NSCache<NSString, NSAttributedString>?) -> some View {
        environment(\.htmlCacheConfiguration, cache.map { .custom($0) } ?? .default)
    }

    public func htmlCacheDisabled(_ disabled: Bool = true) -> some View {
        environment(\.htmlCacheConfiguration, disabled ? .disabled : .default)
    }
}
