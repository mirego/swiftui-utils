import DTCoreText
import Foundation
import SwiftUI
import UIKit

// Module-level cache - shared across all HTMLText views
// NSCache auto-evicts under memory pressure (LRU-like behavior)
private let sharedHTMLCache: NSCache<NSString, NSAttributedString> = {
    let cache = NSCache<NSString, NSAttributedString>()
    cache.countLimit = 100
    cache.name = "com.mirego.swiftui-utils.HTMLCache"
    return cache
}()

struct HTMLStyleSheet {
    var font: HTMLFont = .system
    var lineSpacing: CGFloat?
    var kerning: CGFloat = 0
}

@MainActor
class HTMLTransformer: ObservableObject {
    @Published var html: NSAttributedString = NSAttributedString(string: "")
    
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
        
        if let cached = sharedHTMLCache.object(forKey: cacheKey) {
            html = cached
            return
        }
        
        if let result = DTCoreTextParser.parse(html: string, style: style) {
            sharedHTMLCache.setObject(result, forKey: cacheKey)
            html = result
        } else {
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
