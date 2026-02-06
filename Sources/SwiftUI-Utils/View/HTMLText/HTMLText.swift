import os
import SwiftUI

public struct HTMLFont: Equatable {
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

public struct HTMLText: View {
    @Environment(\.htmlKerning) var kerning
    @Environment(\.htmlFont) var font
    @Environment(\.htmlLineSpacing) var lineSpacing
    @Environment(\.htmlLinkColor) var linkColor
    @Environment(\.htmlCacheConfiguration) var cacheConfiguration

    @StateObject var transformer = HTMLTransformer()
    @State var width: CGFloat?

    let html: String

    public init(html: String) {
        self.html = html
    }

    public var body: some View {
        HTMLAttributedText(attributedString: transformer.html, availableWidth: width)
            .read(\.width, $width)
            .onAppear {
                transformer.cacheConfiguration = cacheConfiguration
                transformer.style = HTMLStyleSheet(font: font, lineSpacing: lineSpacing, kerning: kerning, linkColor: UIColor(linkColor))
                transformer.rawHTML = html
            }
            .onChange(of: cacheConfiguration) { transformer.cacheConfiguration = $0 }
            .onChange(of: font) { transformer.style.font = $0 }
            .onChange(of: lineSpacing) { transformer.style.lineSpacing = $0 }
            .onChange(of: kerning) { transformer.style.kerning = $0 }
            .onChange(of: linkColor) { transformer.style.linkColor = UIColor($0) }
    }
}

struct HTMLAttributedText: UIViewRepresentable {
    @Environment(\.htmlLineLimit) var lineLimit
    @Environment(\.htmlForegroundColor) var foregroundColor
    @Environment(\.htmlLineBreakMode) var lineBreakMode
    @Environment(\.htmlAccessibilityTraits) var accessibilityTraits
    @Environment(\.htmlTextAlignment) var textAlignment
    @Environment(\.htmlOpenURL) var htmlOpenURL

    let attributedString: NSAttributedString
    let width: CGFloat?
    
    init(attributedString content: NSAttributedString, availableWidth: CGFloat?) {
        attributedString = content
        width = availableWidth
    }

    func makeUIView(context: Context) -> UITextView {
        let view = ContentTextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.textContainer.lineFragmentPadding = .zero
        view.textContainerInset = .zero
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if let width {
            textView.frame.size.width = width
        }
        textView.attributedText = attributedString
        textView.textContainer.maximumNumberOfLines = lineLimit ?? 0
        textView.textColor = UIColor(foregroundColor)
        textView.textContainer.lineBreakMode = lineBreakMode
        textView.accessibilityTraits = accessibilityTraits
        textView.textAlignment = textAlignment
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension HTMLAttributedText {

    class Coordinator: NSObject, UITextViewDelegate {
        private let logger = Logger(subsystem: "HTMLText", category: "Coordinator")

        let parent: HTMLAttributedText

        init(_ parent: HTMLAttributedText) {
            self.parent = parent
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            if textView.selectedTextRange != nil {
                textView.selectedTextRange = nil
            }
        }

        func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if let openURL = parent.htmlOpenURL {
                logger.info("Opening URL \(url)")
                openURL(url)
            }
            
            return false
        }
    }

    private class ContentTextView: UITextView {
        override var intrinsicContentSize: CGSize {
            let size = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
            return sizeThatFits(size)
        }
    }
}
