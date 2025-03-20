import os
import SwiftUI

public struct HTMLFont {
    let name: String?
    let size: CGFloat

    public static let system = HTMLFont(name: nil, size: 16)
    public static func system(size: CGFloat) -> Self {
        HTMLFont(name: nil, size: size)
    }
    public static func named(_ name: String, size: CGFloat) -> Self {
        HTMLFont(name: name, size: size)
    }
}

public struct HTMLText: UIViewRepresentable {
    @Environment(\.displayScale) var displayScale
    @Environment(\.openURL) var openURL

    @Environment(\.htmlLineLimit) var lineLimit
    @Environment(\.htmlForegroundColor) var foregroundColor
    @Environment(\.htmlKerning) var kerning
    @Environment(\.htmlFont) var font
    @Environment(\.htmlLineSpacing) var lineSpacing

    let html: String

    public init(html content: String) {
        html = content
    }

    public func makeUIView(context: Context) -> UITextView {
        let view = ContentTextView()

        view.isEditable = false
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.textContainer.lineFragmentPadding = .zero
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = lineLimit ?? 0
        view.textContainerInset = .zero
        view.accessibilityTraits = .staticText
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ textView: UITextView, context: Context) {
        Task { @MainActor in
            textView.attributedText = context.coordinator.format(html: fullHtml)
            textView.textColor = UIColor(foregroundColor)
            textView.textContainer.maximumNumberOfLines = lineLimit ?? 0
            textView.invalidateIntrinsicContentSize()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private var fullHtml: String {
        """
        <html>
        <head>
            <style>
                body {
                    font-family: \(font.name.map { "\($0), " } ?? "")'-apple-system';
                    font-size: \(font.size);
                    line-height: \(lineSpacing.map { "\(displayScale * $0)px" } ?? "normal");
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

extension HTMLText {

    public class Coordinator: NSObject, UITextViewDelegate {
        private let logger = Logger(subsystem: "HTMLText", category: "Coordinator")
        private var cached: (input: String, result: NSAttributedString?)?

        let parent: HTMLText

        init(_ parent: HTMLText) {
            self.parent = parent
        }

        func format(html: String) -> NSAttributedString? {
            guard html != cached?.input else {
                return cached?.result
            }

            let formatter = HtmlToAttributedStringFormatter(kerning: parent.kerning)
            do {
                cached = (html, try formatter.format(html: html))
            } catch {
                logger.warning("\(error.localizedDescription)")
            }
            return cached?.result
        }

        public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            parent.openURL(URL)
            return false
        }
    }

    private struct HtmlToAttributedStringFormatter {
        let kerning: CGFloat

        func format(html string: String) throws -> NSAttributedString? {
            guard
                !string.isEmpty,
                let data = string.data(using: .utf8)
            else { return nil }

            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ]
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: kerning
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
    }

    private class ContentTextView: UITextView {
        override var canBecomeFirstResponder: Bool { false }

        override var intrinsicContentSize: CGSize {
            if frame.height > 0 {
                sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude))
            } else {
                super.intrinsicContentSize
            }
        }
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
