import SwiftUI

/// `Mobile Button` of the Figma library. The tokens have a color for each state of each kind.
struct ChassisButtonStyle: ButtonStyle {
    enum Kind {
        case primary, outline, danger
    }

    var kind: Kind = .primary
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let colors = colors(pressed: configuration.isPressed)
        configuration.label
            .chassisType(.buttonLarge)
            .lineLimit(1)
            .foregroundStyle(.token(colors.foreground))
            .padding(.horizontal, ChassisTokens.SpaceButtonLargePaddingX)
            .padding(.vertical, ChassisTokens.SpaceButtonLargePaddingY)
            .frame(maxWidth: .infinity, minHeight: ChassisTokens.SizeButtonLargeMain)
            .background(
                .token(colors.background),
                in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusButtonLarge)
            )
            .overlay {
                RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusButtonLarge)
                    .strokeBorder(.token(colors.border), lineWidth: ChassisTokens.BorderWidthContextXlarge)
            }
            .contentShape(RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusButtonLarge))
    }

    private func colors(pressed: Bool) -> (foreground: UIColor, background: UIColor, border: UIColor) {
        switch kind {
        case .primary:
            if !isEnabled {
                return (
                    ChassisTokensColor.ColorButtonPrimaryFgDisabled,
                    ChassisTokensColor.ColorButtonPrimaryBgDisabled,
                    ChassisTokensColor.ColorButtonPrimaryBorderDisabled
                )
            }
            return pressed
                ? (
                    ChassisTokensColor.ColorButtonPrimaryFgPress,
                    ChassisTokensColor.ColorButtonPrimaryBgPress,
                    ChassisTokensColor.ColorButtonPrimaryBorderPress
                )
                : (
                    ChassisTokensColor.ColorButtonPrimaryFgIdle,
                    ChassisTokensColor.ColorButtonPrimaryBgIdle,
                    ChassisTokensColor.ColorButtonPrimaryBorderIdle
                )
        case .outline:
            // The secondary button of `Action Bar`: the fill color of the primary as its outline
            let line = isEnabled
                ? (pressed
                    ? ChassisTokensColor.ColorButtonPrimaryBgPress
                    : ChassisTokensColor.ColorButtonPrimaryBgIdle)
                : ChassisTokensColor.ColorButtonPrimaryBgDisabled
            return (line, ChassisTokensColor.ColorContextDefaultTransparentColor, line)
        case .danger:
            return pressed
                ? (
                    ChassisTokensColor.ColorButtonDangerFgPress,
                    ChassisTokensColor.ColorButtonDangerBgPress,
                    ChassisTokensColor.ColorButtonDangerBorderPress
                )
                : (
                    ChassisTokensColor.ColorButtonDangerFgIdle,
                    ChassisTokensColor.ColorButtonDangerBgIdle,
                    ChassisTokensColor.ColorButtonDangerBorderIdle
                )
        }
    }
}

/// `Action Bar` of `Mobile Bottom Navigation`: buttons above the home indicator, side by side.
struct ActionBar<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: ChassisTokens.SpaceContextMedium) {
            content
        }
        .padding(ChassisTokens.SpaceContextMedium)
        .background(.token(ChassisTokensColor.ColorContextDefaultBgEven))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.token(ChassisTokensColor.ColorContextDefaultBorderSubtle))
                .frame(height: ChassisTokens.SizeAssetSeparator)
        }
    }
}

/// `Mobile Nav Segment Bar`. iOS has no way to give its segmented control these tokens.
struct SegmentBar<Value: Hashable>: View {
    let options: [(value: Value, title: String)]
    @Binding var selection: Value
    @Namespace private var selected

    var body: some View {
        HStack(spacing: ChassisTokens.SpaceUnit0) {
            ForEach(options, id: \.value) { option in
                let isSelected = option.value == selection
                Button {
                    withAnimation(ChassisMotion.standard) {
                        selection = option.value
                    }
                } label: {
                    Text(option.title)
                        .chassisType(.segment)
                        .lineLimit(1)
                        // One line in equal parts: a larger size would cut every label short
                        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                        .padding(.horizontal, ChassisTokens.SpaceUnit12)
                        .padding(.vertical, ChassisTokens.SpaceUnit6)
                        .frame(maxWidth: .infinity)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(.token(ChassisTokensColor.ColorContextDefaultBgMain))
                                    .chassisShadow(.small)
                                    .matchedGeometryEffect(id: "selected", in: selected)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
        .padding(ChassisTokens.SpaceUnit2)
        .background(.token(ChassisTokensColor.ColorContextDefaultDimSlight), in: Capsule())
    }
}

/// `_ Search - Basic` of `Mobile Nav Search Bar`.
struct SearchField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: ChassisTokens.SpaceUnit8) {
            Icon(.search, size: ChassisTokens.SizeIconGlyphSmall)
                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
            )
            .chassisType(.bodySmall)
            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
            .autocorrectionDisabled()
            .accessibilityLabel(placeholder)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Icon(.close, size: ChassisTokens.SizeIconGlyphSmall)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                }
                .accessibilityLabel("Clear")
            }
        }
        .padding(ChassisTokens.SpaceUnit12)
        .background(.token(ChassisTokensColor.ColorContextDefaultDimSlight), in: Capsule())
    }
}

/// A text input of the form tokens, with a color for each of its states.
struct ChassisTextField: View {
    enum Status {
        case regular, error, success
    }

    let label: String
    let icon: ChassisIcon
    var placeholder = ""
    var help = ""
    var status: Status = .regular
    var isSecure = false
    @Binding var text: String

    @FocusState private var isFocused: Bool
    @State private var isRevealed = false
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        let colors = colors
        VStack(alignment: .leading, spacing: ChassisTokens.SpaceContext2xsmall) {
            Text(label)
                .chassisType(.inputLabel)
                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
            HStack(spacing: ChassisTokens.SpaceFormInputLargeGap) {
                Icon(icon, size: ChassisTokens.SizeFormInputLargeIcon)
                    .foregroundStyle(.token(colors.foregroundInactive))
                Group {
                    if isSecure && !isRevealed {
                        SecureField("", text: $text, prompt: prompt(colors))
                    } else {
                        TextField("", text: $text, prompt: prompt(colors))
                    }
                }
                .focused($isFocused)
                .chassisType(.inputText)
                .foregroundStyle(.token(colors.foregroundActive))
                .tint(.token(colors.caret))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityLabel(label)
                if isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Icon(isRevealed ? .eyeOff : .eye, size: ChassisTokens.SizeFormInputLargeIcon)
                            .foregroundStyle(.token(colors.foregroundInactive))
                    }
                    .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
                }
            }
            .padding(.horizontal, ChassisTokens.SpaceFormInputLargePaddingX)
            .padding(.vertical, ChassisTokens.SpaceFormInputLargePaddingY)
            .background(
                .token(colors.background),
                in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusFormInputLarge)
            )
            .overlay {
                RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusFormInputLarge)
                    .strokeBorder(.token(colors.border), lineWidth: ChassisTokens.BorderWidthContextMedium)
            }
            if !help.isEmpty {
                Text(help)
                    .chassisType(.assist)
                    .foregroundStyle(.token(colors.help))
            }
        }
    }

    private func prompt(_ colors: FieldColors) -> Text {
        Text(placeholder).foregroundStyle(.token(colors.foregroundInactive))
    }

    private struct FieldColors {
        let background, border, foregroundActive, foregroundInactive, caret, help: UIColor
    }

    private var colors: FieldColors {
        if !isEnabled {
            return FieldColors(
                background: ChassisTokensColor.ColorFormInputDisabledBgRegular,
                border: ChassisTokensColor.ColorFormInputDisabledBorder,
                foregroundActive: ChassisTokensColor.ColorFormInputDisabledFgActive,
                foregroundInactive: ChassisTokensColor.ColorFormInputDisabledFgInactive,
                caret: ChassisTokensColor.ColorFormInputDisabledCaret,
                help: ChassisTokensColor.ColorFormInputDisabledHelp
            )
        }
        switch status {
        case .error:
            return FieldColors(
                background: ChassisTokensColor.ColorFormInputErrorBgRegular,
                border: ChassisTokensColor.ColorFormInputErrorBorder,
                foregroundActive: ChassisTokensColor.ColorFormInputErrorFgActive,
                foregroundInactive: ChassisTokensColor.ColorFormInputErrorFgInactive,
                caret: ChassisTokensColor.ColorFormInputErrorCaret,
                help: ChassisTokensColor.ColorFormInputErrorHelp
            )
        case .success:
            return FieldColors(
                background: ChassisTokensColor.ColorFormInputSuccessBgRegular,
                border: ChassisTokensColor.ColorFormInputSuccessBorder,
                foregroundActive: ChassisTokensColor.ColorFormInputSuccessFgActive,
                foregroundInactive: ChassisTokensColor.ColorFormInputSuccessFgInactive,
                caret: ChassisTokensColor.ColorFormInputSuccessCaret,
                help: ChassisTokensColor.ColorFormInputSuccessHelp
            )
        case .regular:
            return isFocused
                ? FieldColors(
                    background: ChassisTokensColor.ColorFormInputFocusBgRegular,
                    border: ChassisTokensColor.ColorFormInputFocusBorder,
                    foregroundActive: ChassisTokensColor.ColorFormInputFocusFgActive,
                    foregroundInactive: ChassisTokensColor.ColorFormInputFocusFgInactive,
                    caret: ChassisTokensColor.ColorFormInputFocusCaret,
                    help: ChassisTokensColor.ColorFormInputFocusHelp
                )
                : FieldColors(
                    background: ChassisTokensColor.ColorFormInputIdleBgRegular,
                    border: ChassisTokensColor.ColorFormInputIdleBorder,
                    foregroundActive: ChassisTokensColor.ColorFormInputIdleFgActive,
                    foregroundInactive: ChassisTokensColor.ColorFormInputIdleFgInactive,
                    caret: ChassisTokensColor.ColorFormInputIdleCaret,
                    help: ChassisTokensColor.ColorFormInputIdleHelp
                )
        }
    }
}
