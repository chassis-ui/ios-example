import SwiftUI

/// The text styles this app uses, each read whole from the tokens.
extension ChassisType {
    static let h1 = ChassisType(
        family: ChassisTokens.FontContextH1FontFamily,
        weight: ChassisTokens.FontContextH1FontWeight,
        fontStyle: ChassisTokens.FontContextH1FontStyle,
        size: ChassisTokens.FontContextH1FontSize,
        lineHeight: ChassisTokens.FontContextH1LineHeight,
        letterSpacing: ChassisTokens.FontContextH1LetterSpacing,
        scalesLike: .largeTitle
    )

    static let h2 = ChassisType(
        family: ChassisTokens.FontContextH2FontFamily,
        weight: ChassisTokens.FontContextH2FontWeight,
        fontStyle: ChassisTokens.FontContextH2FontStyle,
        size: ChassisTokens.FontContextH2FontSize,
        lineHeight: ChassisTokens.FontContextH2LineHeight,
        letterSpacing: ChassisTokens.FontContextH2LetterSpacing,
        scalesLike: .title
    )

    static let h3 = ChassisType(
        family: ChassisTokens.FontContextH3FontFamily,
        weight: ChassisTokens.FontContextH3FontWeight,
        fontStyle: ChassisTokens.FontContextH3FontStyle,
        size: ChassisTokens.FontContextH3FontSize,
        lineHeight: ChassisTokens.FontContextH3LineHeight,
        letterSpacing: ChassisTokens.FontContextH3LetterSpacing,
        scalesLike: .title2
    )

    static let h4 = ChassisType(
        family: ChassisTokens.FontContextH4FontFamily,
        weight: ChassisTokens.FontContextH4FontWeight,
        fontStyle: ChassisTokens.FontContextH4FontStyle,
        size: ChassisTokens.FontContextH4FontSize,
        lineHeight: ChassisTokens.FontContextH4LineHeight,
        letterSpacing: ChassisTokens.FontContextH4LetterSpacing,
        scalesLike: .title3
    )

    static let h5 = ChassisType(
        family: ChassisTokens.FontContextH5FontFamily,
        weight: ChassisTokens.FontContextH5FontWeight,
        fontStyle: ChassisTokens.FontContextH5FontStyle,
        size: ChassisTokens.FontContextH5FontSize,
        lineHeight: ChassisTokens.FontContextH5LineHeight,
        letterSpacing: ChassisTokens.FontContextH5LetterSpacing,
        scalesLike: .headline
    )

    static let lead = ChassisType(
        family: ChassisTokens.FontContextLeadFontFamily,
        weight: ChassisTokens.FontContextLeadFontWeight,
        fontStyle: ChassisTokens.FontContextLeadFontStyle,
        size: ChassisTokens.FontContextLeadFontSize,
        lineHeight: ChassisTokens.FontContextLeadLineHeight,
        letterSpacing: ChassisTokens.FontContextLeadLetterSpacing,
        scalesLike: .title3
    )

    static let titleLarge = ChassisType(
        family: ChassisTokens.FontContextTitleLargeFontFamily,
        weight: ChassisTokens.FontContextTitleLargeFontWeight,
        fontStyle: ChassisTokens.FontContextTitleLargeFontStyle,
        size: ChassisTokens.FontContextTitleLargeFontSize,
        lineHeight: ChassisTokens.FontContextTitleLargeLineHeight,
        letterSpacing: ChassisTokens.FontContextTitleLargeLetterSpacing,
        scalesLike: .title3
    )

    static let titleMedium = ChassisType(
        family: ChassisTokens.FontContextTitleMediumFontFamily,
        weight: ChassisTokens.FontContextTitleMediumFontWeight,
        fontStyle: ChassisTokens.FontContextTitleMediumFontStyle,
        size: ChassisTokens.FontContextTitleMediumFontSize,
        lineHeight: ChassisTokens.FontContextTitleMediumLineHeight,
        letterSpacing: ChassisTokens.FontContextTitleMediumLetterSpacing,
        scalesLike: .headline
    )

    static let titleSmall = ChassisType(
        family: ChassisTokens.FontContextTitleSmallFontFamily,
        weight: ChassisTokens.FontContextTitleSmallFontWeight,
        fontStyle: ChassisTokens.FontContextTitleSmallFontStyle,
        size: ChassisTokens.FontContextTitleSmallFontSize,
        lineHeight: ChassisTokens.FontContextTitleSmallLineHeight,
        letterSpacing: ChassisTokens.FontContextTitleSmallLetterSpacing,
        scalesLike: .headline
    )

    static let bodyLarge = ChassisType(
        family: ChassisTokens.FontContextBodyLargeFontFamily,
        weight: ChassisTokens.FontContextBodyLargeFontWeight,
        fontStyle: ChassisTokens.FontContextBodyLargeFontStyle,
        size: ChassisTokens.FontContextBodyLargeFontSize,
        lineHeight: ChassisTokens.FontContextBodyLargeLineHeight,
        letterSpacing: ChassisTokens.FontContextBodyLargeLetterSpacing,
        scalesLike: .body
    )

    static let bodyMedium = ChassisType(
        family: ChassisTokens.FontContextBodyMediumFontFamily,
        weight: ChassisTokens.FontContextBodyMediumFontWeight,
        fontStyle: ChassisTokens.FontContextBodyMediumFontStyle,
        size: ChassisTokens.FontContextBodyMediumFontSize,
        lineHeight: ChassisTokens.FontContextBodyMediumLineHeight,
        letterSpacing: ChassisTokens.FontContextBodyMediumLetterSpacing,
        scalesLike: .body
    )

    static let bodySmall = ChassisType(
        family: ChassisTokens.FontContextBodySmallFontFamily,
        weight: ChassisTokens.FontContextBodySmallFontWeight,
        fontStyle: ChassisTokens.FontContextBodySmallFontStyle,
        size: ChassisTokens.FontContextBodySmallFontSize,
        lineHeight: ChassisTokens.FontContextBodySmallLineHeight,
        letterSpacing: ChassisTokens.FontContextBodySmallLetterSpacing,
        scalesLike: .subheadline
    )

    static let labelLarge = ChassisType(
        family: ChassisTokens.FontContextLabelLargeFontFamily,
        weight: ChassisTokens.FontContextLabelLargeFontWeight,
        fontStyle: ChassisTokens.FontContextLabelLargeFontStyle,
        size: ChassisTokens.FontContextLabelLargeFontSize,
        lineHeight: ChassisTokens.FontContextLabelLargeLineHeight,
        letterSpacing: ChassisTokens.FontContextLabelLargeLetterSpacing,
        scalesLike: .callout
    )

    static let labelMedium = ChassisType(
        family: ChassisTokens.FontContextLabelMediumFontFamily,
        weight: ChassisTokens.FontContextLabelMediumFontWeight,
        fontStyle: ChassisTokens.FontContextLabelMediumFontStyle,
        size: ChassisTokens.FontContextLabelMediumFontSize,
        lineHeight: ChassisTokens.FontContextLabelMediumLineHeight,
        letterSpacing: ChassisTokens.FontContextLabelMediumLetterSpacing,
        scalesLike: .subheadline
    )

    static let labelSmall = ChassisType(
        family: ChassisTokens.FontContextLabelSmallFontFamily,
        weight: ChassisTokens.FontContextLabelSmallFontWeight,
        fontStyle: ChassisTokens.FontContextLabelSmallFontStyle,
        size: ChassisTokens.FontContextLabelSmallFontSize,
        lineHeight: ChassisTokens.FontContextLabelSmallLineHeight,
        letterSpacing: ChassisTokens.FontContextLabelSmallLetterSpacing,
        scalesLike: .caption
    )

    static let code = ChassisType(
        family: ChassisTokens.FontCodeMediumNormalFontFamily,
        weight: ChassisTokens.FontCodeMediumNormalFontWeight,
        fontStyle: ChassisTokens.FontCodeMediumNormalFontStyle,
        size: ChassisTokens.FontCodeMediumNormalFontSize,
        lineHeight: ChassisTokens.FontCodeMediumNormalLineHeight,
        letterSpacing: ChassisTokens.FontCodeMediumNormalLetterSpacing,
        scalesLike: .body
    )

    static let buttonLarge = ChassisType(
        family: ChassisTokens.FontButtonLargeFontFamily,
        weight: ChassisTokens.FontButtonLargeFontWeight,
        fontStyle: ChassisTokens.FontButtonLargeFontStyle,
        size: ChassisTokens.FontButtonLargeFontSize,
        lineHeight: ChassisTokens.FontButtonLargeLineHeight,
        letterSpacing: ChassisTokens.FontButtonLargeLetterSpacing,
        scalesLike: .body
    )

    static let buttonMedium = ChassisType(
        family: ChassisTokens.FontButtonMediumFontFamily,
        weight: ChassisTokens.FontButtonMediumFontWeight,
        fontStyle: ChassisTokens.FontButtonMediumFontStyle,
        size: ChassisTokens.FontButtonMediumFontSize,
        lineHeight: ChassisTokens.FontButtonMediumLineHeight,
        letterSpacing: ChassisTokens.FontButtonMediumLetterSpacing,
        scalesLike: .callout
    )

    static let buttonSmall = ChassisType(
        family: ChassisTokens.FontButtonSmallFontFamily,
        weight: ChassisTokens.FontButtonSmallFontWeight,
        fontStyle: ChassisTokens.FontButtonSmallFontStyle,
        size: ChassisTokens.FontButtonSmallFontSize,
        lineHeight: ChassisTokens.FontButtonSmallLineHeight,
        letterSpacing: ChassisTokens.FontButtonSmallLetterSpacing,
        scalesLike: .subheadline
    )

    static let badge = ChassisType(
        family: ChassisTokens.FontBadgeSmallFontFamily,
        weight: ChassisTokens.FontBadgeSmallFontWeight,
        fontStyle: ChassisTokens.FontBadgeSmallFontStyle,
        size: ChassisTokens.FontBadgeSmallFontSize,
        lineHeight: ChassisTokens.FontBadgeSmallLineHeight,
        letterSpacing: ChassisTokens.FontBadgeSmallLetterSpacing,
        scalesLike: .caption2
    )

    static let chip = ChassisType(
        family: ChassisTokens.FontChipMediumFontFamily,
        weight: ChassisTokens.FontChipMediumFontWeight,
        fontStyle: ChassisTokens.FontChipMediumFontStyle,
        size: ChassisTokens.FontChipMediumFontSize,
        lineHeight: ChassisTokens.FontChipMediumLineHeight,
        letterSpacing: ChassisTokens.FontChipMediumLetterSpacing,
        scalesLike: .subheadline
    )

    static let cardTitle = ChassisType(
        family: ChassisTokens.FontCardMediumTitleFontFamily,
        weight: ChassisTokens.FontCardMediumTitleFontWeight,
        fontStyle: ChassisTokens.FontCardMediumTitleFontStyle,
        size: ChassisTokens.FontCardMediumTitleFontSize,
        lineHeight: ChassisTokens.FontCardMediumTitleLineHeight,
        letterSpacing: ChassisTokens.FontCardMediumTitleLetterSpacing,
        scalesLike: .headline
    )

    static let cardSubtitle = ChassisType(
        family: ChassisTokens.FontCardMediumSubtitleFontFamily,
        weight: ChassisTokens.FontCardMediumSubtitleFontWeight,
        fontStyle: ChassisTokens.FontCardMediumSubtitleFontStyle,
        size: ChassisTokens.FontCardMediumSubtitleFontSize,
        lineHeight: ChassisTokens.FontCardMediumSubtitleLineHeight,
        letterSpacing: ChassisTokens.FontCardMediumSubtitleLetterSpacing,
        scalesLike: .subheadline
    )

    static let cardBody = ChassisType(
        family: ChassisTokens.FontCardMediumBodyFontFamily,
        weight: ChassisTokens.FontCardMediumBodyFontWeight,
        fontStyle: ChassisTokens.FontCardMediumBodyFontStyle,
        size: ChassisTokens.FontCardMediumBodyFontSize,
        lineHeight: ChassisTokens.FontCardMediumBodyLineHeight,
        letterSpacing: ChassisTokens.FontCardMediumBodyLetterSpacing,
        scalesLike: .subheadline
    )

    static let inputLabel = ChassisType(
        family: ChassisTokens.FontFormInputLargeLabelFontFamily,
        weight: ChassisTokens.FontFormInputLargeLabelFontWeight,
        fontStyle: ChassisTokens.FontFormInputLargeLabelFontStyle,
        size: ChassisTokens.FontFormInputLargeLabelFontSize,
        lineHeight: ChassisTokens.FontFormInputLargeLabelLineHeight,
        letterSpacing: ChassisTokens.FontFormInputLargeLabelLetterSpacing,
        scalesLike: .subheadline
    )

    static let inputText = ChassisType(
        family: ChassisTokens.FontFormInputLargeTextFontFamily,
        weight: ChassisTokens.FontFormInputLargeTextFontWeight,
        fontStyle: ChassisTokens.FontFormInputLargeTextFontStyle,
        size: ChassisTokens.FontFormInputLargeTextFontSize,
        lineHeight: ChassisTokens.FontFormInputLargeTextLineHeight,
        letterSpacing: ChassisTokens.FontFormInputLargeTextLetterSpacing,
        scalesLike: .body
    )

    static let assist = ChassisType(
        family: ChassisTokens.FontAssistMediumFontFamily,
        weight: ChassisTokens.FontAssistMediumFontWeight,
        fontStyle: ChassisTokens.FontAssistMediumFontStyle,
        size: ChassisTokens.FontAssistMediumFontSize,
        lineHeight: ChassisTokens.FontAssistMediumLineHeight,
        letterSpacing: ChassisTokens.FontAssistMediumLetterSpacing,
        scalesLike: .caption
    )

    static let notificationTitle = ChassisType(
        family: ChassisTokens.FontNotificationTitleFontFamily,
        weight: ChassisTokens.FontNotificationTitleFontWeight,
        fontStyle: ChassisTokens.FontNotificationTitleFontStyle,
        size: ChassisTokens.FontNotificationTitleFontSize,
        lineHeight: ChassisTokens.FontNotificationTitleLineHeight,
        letterSpacing: ChassisTokens.FontNotificationTitleLetterSpacing,
        scalesLike: .subheadline
    )

    static let notificationMessage = ChassisType(
        family: ChassisTokens.FontNotificationMessageFontFamily,
        weight: ChassisTokens.FontNotificationMessageFontWeight,
        fontStyle: ChassisTokens.FontNotificationMessageFontStyle,
        size: ChassisTokens.FontNotificationMessageFontSize,
        lineHeight: ChassisTokens.FontNotificationMessageLineHeight,
        letterSpacing: ChassisTokens.FontNotificationMessageLetterSpacing,
        scalesLike: .subheadline
    )

    static let sectionHeader = ChassisType(
        family: ChassisTokens.FontSectionHeaderMediumFontFamily,
        weight: ChassisTokens.FontSectionHeaderMediumFontWeight,
        fontStyle: ChassisTokens.FontSectionHeaderMediumFontStyle,
        size: ChassisTokens.FontSectionHeaderMediumFontSize,
        lineHeight: ChassisTokens.FontSectionHeaderMediumLineHeight,
        letterSpacing: ChassisTokens.FontSectionHeaderMediumLetterSpacing,
        scalesLike: .headline
    )

    static let navTitle = ChassisType(
        family: ChassisTokens.FontUiMediumStrongFontFamily,
        weight: ChassisTokens.FontUiMediumStrongFontWeight,
        fontStyle: ChassisTokens.FontUiMediumStrongFontStyle,
        size: ChassisTokens.FontUiMediumStrongFontSize,
        lineHeight: ChassisTokens.FontUiMediumStrongLineHeight,
        letterSpacing: ChassisTokens.FontUiMediumStrongLetterSpacing,
        scalesLike: .headline
    )

    static let segment = ChassisType(
        family: ChassisTokens.FontUiSmallStrongFontFamily,
        weight: ChassisTokens.FontUiSmallStrongFontWeight,
        fontStyle: ChassisTokens.FontUiSmallStrongFontStyle,
        size: ChassisTokens.FontUiSmallStrongFontSize,
        lineHeight: ChassisTokens.FontUiSmallStrongLineHeight,
        letterSpacing: ChassisTokens.FontUiSmallStrongLetterSpacing,
        scalesLike: .subheadline
    )

    static let tab = ChassisType(
        family: ChassisTokens.FontUi2xsmallNormalFontFamily,
        weight: ChassisTokens.FontUi2xsmallNormalFontWeight,
        fontStyle: ChassisTokens.FontUi2xsmallNormalFontStyle,
        size: ChassisTokens.FontUi2xsmallNormalFontSize,
        lineHeight: ChassisTokens.FontUi2xsmallNormalLineHeight,
        letterSpacing: ChassisTokens.FontUi2xsmallNormalLetterSpacing,
        scalesLike: .caption2
    )

    /// Every style with its name, which the launch check and the Foundations tab walk through
    static let all: [(name: String, type: ChassisType)] = [
        ("h1", h1),
        ("h2", h2),
        ("h3", h3),
        ("h4", h4),
        ("h5", h5),
        ("lead", lead),
        ("titleLarge", titleLarge),
        ("titleMedium", titleMedium),
        ("titleSmall", titleSmall),
        ("bodyLarge", bodyLarge),
        ("bodyMedium", bodyMedium),
        ("bodySmall", bodySmall),
        ("labelLarge", labelLarge),
        ("labelMedium", labelMedium),
        ("labelSmall", labelSmall),
        ("code", code),
        ("buttonLarge", buttonLarge),
        ("buttonMedium", buttonMedium),
        ("buttonSmall", buttonSmall),
        ("badge", badge),
        ("chip", chip),
        ("cardTitle", cardTitle),
        ("cardSubtitle", cardSubtitle),
        ("cardBody", cardBody),
        ("inputLabel", inputLabel),
        ("inputText", inputText),
        ("assist", assist),
        ("notificationTitle", notificationTitle),
        ("notificationMessage", notificationMessage),
        ("sectionHeader", sectionHeader),
        ("navTitle", navTitle),
        ("segment", segment),
        ("tab", tab),
    ]
}
