import SwiftUI

/// A text style of the tokens, with the text style of iOS that it grows with under Dynamic Type.
struct ChassisType: Sendable {
    let family: String
    let weight: UIFont.Weight
    let fontStyle: String
    let size: CGFloat
    let lineHeight: CGFloat
    let letterSpacing: CGFloat
    let scalesLike: Font.TextStyle

    var isItalic: Bool { fontStyle == "italic" }

    /// The font for UIKit appearances, which have no modifier to scale it.
    var uiFont: UIFont {
        let name = ChassisFonts.postScriptName(of: self)
        let font = UIFont(name: name, size: size) ?? .preferredFont(forTextStyle: .body)
        return UIFontMetrics.default.scaledFont(for: font)
    }
}

/// Sets a text style: the font, its line height and its letter spacing, scaled by Dynamic Type.
private struct ChassisTypeModifier: ViewModifier {
    let type: ChassisType
    @ScaledMetric private var scale: CGFloat

    init(type: ChassisType) {
        self.type = type
        _scale = ScaledMetric(wrappedValue: 1, relativeTo: type.scalesLike)
    }

    func body(content: Content) -> some View {
        let name = ChassisFonts.postScriptName(of: type)
        let size = type.size * scale
        // What the font leaves of the line height of the tokens
        let fontLine = UIFont(name: name, size: size)?.lineHeight ?? size
        let leading = max(0, type.lineHeight * scale - fontLine)
        content
            .font(.custom(name, fixedSize: size))
            .tracking(type.letterSpacing * scale)
            .lineSpacing(leading)
            .padding(.vertical, leading / 2)
    }
}

extension View {
    func chassisType(_ type: ChassisType) -> some View {
        modifier(ChassisTypeModifier(type: type))
    }
}
