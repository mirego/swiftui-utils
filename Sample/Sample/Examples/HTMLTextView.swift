import SwiftUI

struct HTMLTextView: View {
    @State var urlToOpen: URL?

    var body: some View {
        ScrollView {
            VStack {
                HTMLText(html: "<h1>HTML tests</h1>")
                    .padding()
                    .background {
                        RoundedCorner(radius: 12)
                            .strokeBorder(.tertiary)
                    }
                HTMLText(html: "<h2>First test</h2>")
                    .padding()
                    .background {
                        RoundedCorner(radius: 12)
                            .strokeBorder(.tertiary)
                    }
                HTMLText(html: "<p>A <b>paragraph</b>. It's longer, and wider, and better. It should be on 2 lines, hopefully. </p>")
                    .padding()
                    .background {
                        RoundedCorner(radius: 12)
                            .strokeBorder(.tertiary)
                    }
                HTMLText(html: "<h2>Second test</h2>")
                    .padding()
                    .background {
                        RoundedCorner(radius: 12)
                            .strokeBorder(.tertiary)
                    }
                HTMLText(html: "<i>This is a lonely italic line. </i>")
                    .padding()
                    .background {
                        RoundedCorner(radius: 12)
                            .strokeBorder(.tertiary)
                    }

                HTMLText(html: """
                    <h1>HTML tests</h1>
                    <h2>First test</h2>
                    <p>There are some paragraphs. </p>
                    <p>Another <b>one</b>. But longer, and wider, and better. It should be on 2 lines, hopefully. </p>
                    <h2>Second test</h2>
                    <i>This is a lonely italic line. </i>
                    <ul>
                        <li>Numéro 1</li>
                        <li>Numéro 2</li>
                        <li>Numéro 3</li>
                    </ul>
                    <p>There something in the <a href="https://apple.com">air</a>...</p>
                    Oh, okay.
                    """
                )
                .padding()
                .background {
                    RoundedCorner(radius: 12)
                        .strokeBorder(.tertiary)
                }
            }
            .padding()
            .htmlFont(.named("Menlo"))
            .htmlBaseFontSize(16)
            .htmlForegroundColor(.secondary)
            .htmlKerning(0)
            .htmlLineSpacing(8)
            .environment(\.openURL, OpenURLAction { url in
                withAnimation(.snappy) {
                    urlToOpen = url
                }
                return .handled
            })
        }
        .safeAreaInset(edge: .bottom) {
            if let urlToOpen {
                button(url: urlToOpen)
                    .transition(.move(edge: .bottom))
            }
        }
    }

    @ViewBuilder
    func button(url: URL) -> some View {
        Button {
            UIApplication.shared.open(url)
            withAnimation(.snappy) {
                self.urlToOpen = nil
            }
        } label: {
            Label("Open link in Safari", systemImage: "rectangle.portrait.and.arrow.forward")
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                }
        }
    }
}

#Preview {
    HTMLTextView()
}
