import SwiftUI

extension View {
    public func readSize(_ size: Binding<CGSize>) -> some View {
        readSize {
            size.wrappedValue = $0
        }
    }

    @ViewBuilder
    public func readSize(_ reader: @escaping (CGSize) -> Void) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGSize.self, of: \.size, action: reader)
        } else {
            background(FrameGetter(coordinateSpace: .local))
                .onPreferenceChange(FramePreferenceKey.self) {
                    reader($0.size)
                }
        }
    }

    public func readLocalFrame(_ frame: Binding<CGRect>) -> some View {
        readLocalFrame {
            frame.wrappedValue = $0
        }
    }

    @ViewBuilder
    public func readLocalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGRect.self, of: { $0.frame(in: .local) }, action: reader)
        } else {
            background(FrameGetter(coordinateSpace: .local))
                .onPreferenceChange(FramePreferenceKey.self) {
                    reader($0)
                }
        }
    }

    public func readGlobalFrame(_ frame: Binding<CGRect>) -> some View {
        readGlobalFrame {
            frame.wrappedValue = $0
        }
    }

    @ViewBuilder
    public func readGlobalFrame(_ reader: @escaping (CGRect) -> Void) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }, action: reader)
        } else {
            background(FrameGetter(coordinateSpace: .global))
                .onPreferenceChange(FramePreferenceKey.self) {
                    reader($0)
                }
        }
    }

    @ViewBuilder
    public func readNamedFrame(coordinateName: String, _ reader: @escaping (CGRect) -> Void) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGRect.self, of: { $0.frame(in: .named(coordinateName)) }, action: reader)
        } else {
            background(FrameGetter(coordinateSpace: .named(coordinateName)))
                .onPreferenceChange(FramePreferenceKey.self) {
                    reader($0)
                }
        }
    }

    public func readNamedFrame(coordinateName: String, _ frame: Binding<CGRect>) -> some View {
        readNamedFrame(coordinateName: coordinateName) {
            frame.wrappedValue = $0
        }
    }

    @ViewBuilder
    public func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ reader: @escaping (CGFloat) -> Void
    ) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGFloat.self, of: { $0.frame(in: coordinateSpace)[keyPath: keyPath] }, action: reader)
        } else {
            background(SingleDimensionGetter(coordinateSpace: coordinateSpace, keyPath: keyPath))
                .onPreferenceChange(SingleDimensionPreferenceKey.self) {
                    reader($0)
                }
        }
    }

    public func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ dimension: Binding<CGFloat>
    ) -> some View {
        read(keyPath, in: coordinateSpace) {
            dimension.wrappedValue = $0
        }
    }

    @ViewBuilder
    public func read(
        _ keyPath: KeyPath<CGRect, CGFloat>,
        in coordinateSpace: CoordinateSpace = .local,
        _ dimension: Binding<CGFloat?>
    ) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(for: CGFloat.self, of: { $0.frame(in: coordinateSpace)[keyPath: keyPath] }) {
                dimension.wrappedValue = $0
            }
        } else {
            background(SingleDimensionGetter(coordinateSpace: coordinateSpace, keyPath: keyPath))
                .onPreferenceChange(SingleDimensionPreferenceKey.self) {
                    dimension.wrappedValue = $0
                }
        }
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}

    typealias Value = CGRect
}

private struct FrameGetter: View {
    let coordinateSpace: CoordinateSpace

    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: FramePreferenceKey.self,
                value: geometry.frame(in: coordinateSpace)
            )
        }
    }
}

private struct SingleDimensionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

private struct SingleDimensionGetter: View {
    let coordinateSpace: CoordinateSpace
    let keyPath: KeyPath<CGRect, CGFloat>

    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(
                key: SingleDimensionPreferenceKey.self,
                value: geometry.frame(in: coordinateSpace)[keyPath: keyPath]
            )
        }
    }
}
