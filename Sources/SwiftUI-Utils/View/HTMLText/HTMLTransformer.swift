import DTCoreText
import Foundation
import os
import SwiftUI
import UIKit

public final class HTMLCacheManager: NSObject, NSCacheDelegate {
    private let logger = Logger(subsystem: "SwiftUI-Utils", category: "HTMLCache")
    private let cache = NSCache<NSString, NSAttributedString>()

    public override init() {
        super.init()
        cache.name = "com.mirego.swiftui-utils.HTMLCache.\(ObjectIdentifier(self))"
        cache.countLimit = 50
        cache.delegate = self
    }

    func get(forKey key: NSString) -> NSAttributedString? {
        cache.object(forKey: key)
    }

    func set(_ value: NSAttributedString, forKey key: NSString) {
        cache.setObject(value, forKey: key)
    }

    public func clear() {
        cache.removeAllObjects()
    }

    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        #if DEBUG
        logger.debug("Cache evicting object")
        #endif
    }
}

private struct HTMLCacheEnvironmentKey: EnvironmentKey {
    static let defaultValue: HTMLCacheManager? = nil
}

public extension EnvironmentValues {
    var htmlCache: HTMLCacheManager? {
        get { self[HTMLCacheEnvironmentKey.self] }
        set { self[HTMLCacheEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func htmlCache(_ cache: HTMLCacheManager) -> some View {
        environment(\.htmlCache, cache)
    }
}

struct HTMLStyleSheet {
    var font: HTMLFont = .system
    var lineSpacing: CGFloat?
    var kerning: CGFloat = 0
}

@MainActor
class HTMLTransformer: ObservableObject {
    private let logger = Logger(subsystem: "HTMLText", category: "Transformer")

    @Published var html: NSAttributedString = NSAttributedString(string: "")

    private lazy var localCache = HTMLCacheManager()
    var sharedCache: HTMLCacheManager?

    private var cache: HTMLCacheManager {
        sharedCache ?? localCache
    }

    var style: HTMLStyleSheet = HTMLStyleSheet() {
        didSet { update(html: rawHTML, using: style) }
    }
    var rawHTML: String = "" {
        didSet { update(html: rawHTML, using: style) }
    }

    private func update(html string: String, using style: HTMLStyleSheet) {
        guard !string.isEmpty else {
            html = NSAttributedString(string: "")
            return
        }

        let cacheKey = "\(string.hashValue)_\(style.font.name ?? "system")_\(style.font.size)_\(style.lineSpacing ?? 0)_\(style.kerning)" as NSString

        if let cached = cache.get(forKey: cacheKey) {
            html = cached
            return
        }

        let result = DTCoreTextParser.parse(html: string, style: style)
        if let result {
            cache.set(result, forKey: cacheKey)
            html = result
        } else {
            logger.warning("Failed to parse HTML")
            html = NSAttributedString(string: "")
        }
    }
}

private enum DTCoreTextParser {

    static func parse(html: String, style: HTMLStyleSheet) -> NSAttributedString? {
        let styledHTML = """
        <html>
        <head>
            <style>
                body {
                    font-family: \(style.font.name.map { "\($0), " } ?? "")'-apple-system';
                    font-size: \(style.font.size);
                    line-height: \(style.lineSpacing.map { "\($0)px" } ?? "normal");
                    -webkit-text-size-adjust: none;
                    margin: 0;
                }
                a {
                    text-decoration: none;
                }
            </style>
        </head>
        <body>
            \(html)
        </body>
        </html>
        """

        guard let data = styledHTML.data(using: .utf8) else { return nil }

        let options: [String: Any] = [
            DTUseiOS6Attributes: true,
            DTDefaultFontFamily: style.font.name ?? "-apple-system",
            DTDefaultFontSize: style.font.size,
            DTDefaultLinkColor: UIColor.link,
            DTDefaultLinkDecoration: false
        ]

        guard let builder = DTHTMLAttributedStringBuilder(
            html: data,
            options: options,
            documentAttributes: nil
        ), let attributedString = builder.generatedAttributedString() else {
            return nil
        }

        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        let fullRange = NSRange(location: 0, length: mutableString.length)
        mutableString.addAttribute(.kern, value: style.kerning, range: fullRange)

        return mutableString.trimmingTrailingCharacters(in: .newlines)
    }
}

extension NSMutableAttributedString {

    func trimmingTrailingCharacters(in characters: CharacterSet) -> NSMutableAttributedString {
        guard !string.isEmpty else {
            return self
        }

        let attributedString = NSMutableAttributedString(attributedString: self)
        while let last = attributedString.string.unicodeScalars.last, characters.contains(last) {
            attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
        }

        return attributedString
    }
}
