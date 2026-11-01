import CoreText
import UIKit

/// The font files of the brand, named by role and weight: `ui_normal.ttf`, `display_mass.ttf`.
/// Which family a role holds is the choice of the brand, so no family name is in this app:
/// the name of a font is read from its file.
enum ChassisFonts {
    /// The PostScript name of each file, by the name of the file without its extension
    private static let postScriptNames: [String: String] = {
        let urls = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: "fonts") ?? []
        var names: [String: String] = [:]
        for url in urls {
            let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor]
            guard let descriptor = descriptors?.first,
                  let name = CTFontDescriptorCopyAttribute(descriptor, kCTFontNameAttribute) as? String
            else { continue }
            names[url.deletingPathExtension().lastPathComponent] = name
            // A role in the family of another role is a copy with one PostScript name. The
            // second file reports a duplicate, and the font is loaded.
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        return names
    }()

    /// Registers the files, and resolves every style at launch: a style without a file of the
    /// brand stops the app here, not on the first screen that uses it.
    static func register() {
        for style in ChassisType.all {
            _ = postScriptName(of: style.type)
        }
    }

    /// The PostScript name of the file that a style of the tokens resolves to.
    static func postScriptName(of type: ChassisType) -> String {
        let file = fileName(of: type)
        guard let name = postScriptNames[file] else {
            preconditionFailure("The brand has no font file \(file).ttf")
        }
        return name
    }

    /// The file of a style: the role with the family and the weight that the tokens give it.
    static func fileName(of type: ChassisType) -> String {
        for role in FontRole.allCases where role.family == type.family {
            if let weight = role.weights.first(where: { $0.value == type.weight }) {
                return "\(role.rawValue)_\(weight.name)\(type.isItalic ? "_italic" : "")"
            }
        }
        preconditionFailure("No role of the tokens has \(type.family) at weight \(type.weight)")
    }
}

/// The font roles of the tokens, with the family and the weights of each in this brand.
private enum FontRole: String, CaseIterable {
    case display, ui, prose, code

    var family: String {
        switch self {
        case .display: ChassisTokens.TypographyFontFamilyDisplay
        case .ui: ChassisTokens.TypographyFontFamilyUi
        case .prose: ChassisTokens.TypographyFontFamilyProse
        case .code: ChassisTokens.TypographyFontFamilyCode
        }
    }

    var weights: [(name: String, value: UIFont.Weight)] {
        switch self {
        case .display:
            [
                ("elegant", ChassisTokens.TypographyFontWeightDisplayElegantWeight),
                ("normal", ChassisTokens.TypographyFontWeightDisplayNormalWeight),
                ("strong", ChassisTokens.TypographyFontWeightDisplayStrongWeight),
                ("mass", ChassisTokens.TypographyFontWeightDisplayMassWeight)
            ]
        case .ui:
            [
                ("elegant", ChassisTokens.TypographyFontWeightUiElegantWeight),
                ("normal", ChassisTokens.TypographyFontWeightUiNormalWeight),
                ("strong", ChassisTokens.TypographyFontWeightUiStrongWeight),
                ("mass", ChassisTokens.TypographyFontWeightUiMassWeight)
            ]
        case .prose:
            [
                ("elegant", ChassisTokens.TypographyFontWeightProseElegantWeight),
                ("normal", ChassisTokens.TypographyFontWeightProseNormalWeight),
                ("strong", ChassisTokens.TypographyFontWeightProseStrongWeight),
                ("mass", ChassisTokens.TypographyFontWeightProseMassWeight)
            ]
        case .code:
            [
                ("normal", ChassisTokens.TypographyFontWeightCodeNormalWeight),
                ("strong", ChassisTokens.TypographyFontWeightCodeStrongWeight)
            ]
        }
    }
}
