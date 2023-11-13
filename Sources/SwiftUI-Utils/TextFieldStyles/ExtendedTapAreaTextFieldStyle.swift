import SwiftUI

public struct ExtendedTapAreaTextFieldStyle: TextFieldStyle {
    @FocusState private var textFieldFocused: Bool

    let extraTapArea: CGFloat

    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, extraTapArea)
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
            .padding(.vertical, -extraTapArea)
    }
}

public extension TextFieldStyle where Self == ExtendedTapAreaTextFieldStyle {
    static func extendedTapArea(_ extraTapArea: CGFloat = 16) -> ExtendedTapAreaTextFieldStyle {
        ExtendedTapAreaTextFieldStyle(extraTapArea: extraTapArea)
    }
}
