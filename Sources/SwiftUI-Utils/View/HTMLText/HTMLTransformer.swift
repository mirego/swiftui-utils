import Foundation
import os

struct HTMLStyleSheet {
    var font: HTMLFont = .system
    var lineSpacing: CGFloat?
    var kerning: CGFloat = 0
}

class HTMLTransformer: ObservableObject {
    private let logger = Logger(subsystem: "HTMLText", category: "Transformer")
    
    @Published var html: NSAttributedString = NSAttributedString(string: "")
    
    var style: HTMLStyleSheet = HTMLStyleSheet() {
        didSet { update(html: rawHTML, using: style) }
    }
    var rawHTML: String = "" {
        didSet { update(html: rawHTML, using: style) }
    }
    
    private func update(html string: String, using style: HTMLStyleSheet) {
        guard !string.isEmpty else {
            return
        }
        
        let formatter = HtmlStringToAttributedStringFormatter(style: style)
        do {
            html = try formatter.format(html: string) ?? NSAttributedString(string: "")
        } catch {
            logger.warning("\(error.localizedDescription)")
            html = NSAttributedString(string: "")
        }
    }
}

private struct HtmlStringToAttributedStringFormatter {
    let style: HTMLStyleSheet

    func format(html string: String) throws -> NSAttributedString? {
        guard
            !string.isEmpty,
            let data = embedHTML(string).data(using: .utf8)
        else { return nil }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: style.kerning,
        ]

        let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(attributes, range: range)
        attributedString.enumerateAttribute(.link, in: range) { value, range, _ in
            guard value != nil else { return }
            attributedString.removeAttribute(.underlineStyle, range: range)
        }
        return attributedString.trimmingTrailingCharacters(in: .newlines)
    }
    
    private func embedHTML(_ html: String) -> String {
        """
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
