import SwiftUI

extension ShapeStyle where Self == Color {
    /// A color token, which follows light and dark by itself.
    static func token(_ color: UIColor) -> Color {
        Color(uiColor: color)
    }
}

/// A shadow of the tokens, always two layers. SwiftUI has no spread, so that value goes unused.
struct ChassisShadow {
    struct Layer {
        let color: UIColor
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    let first: Layer
    let second: Layer

    static let card = ChassisShadow(
        first: Layer(
            color: ChassisTokens.ShadowCardMain1Color,
            radius: ChassisTokens.ShadowCardMain1Radius,
            x: ChassisTokens.ShadowCardMain1OffsetX,
            y: ChassisTokens.ShadowCardMain1OffsetY
        ),
        second: Layer(
            color: ChassisTokens.ShadowCardMain2Color,
            radius: ChassisTokens.ShadowCardMain2Radius,
            x: ChassisTokens.ShadowCardMain2OffsetX,
            y: ChassisTokens.ShadowCardMain2OffsetY
        )
    )

    static let small = ChassisShadow(
        first: Layer(
            color: ChassisTokens.ShadowContextSmall1Color,
            radius: ChassisTokens.ShadowContextSmall1Radius,
            x: ChassisTokens.ShadowContextSmall1OffsetX,
            y: ChassisTokens.ShadowContextSmall1OffsetY
        ),
        second: Layer(
            color: ChassisTokens.ShadowContextSmall2Color,
            radius: ChassisTokens.ShadowContextSmall2Radius,
            x: ChassisTokens.ShadowContextSmall2OffsetX,
            y: ChassisTokens.ShadowContextSmall2OffsetY
        )
    )

    static let medium = ChassisShadow(
        first: Layer(
            color: ChassisTokens.ShadowContextMedium1Color,
            radius: ChassisTokens.ShadowContextMedium1Radius,
            x: ChassisTokens.ShadowContextMedium1OffsetX,
            y: ChassisTokens.ShadowContextMedium1OffsetY
        ),
        second: Layer(
            color: ChassisTokens.ShadowContextMedium2Color,
            radius: ChassisTokens.ShadowContextMedium2Radius,
            x: ChassisTokens.ShadowContextMedium2OffsetX,
            y: ChassisTokens.ShadowContextMedium2OffsetY
        )
    )

    static let large = ChassisShadow(
        first: Layer(
            color: ChassisTokens.ShadowContextLarge1Color,
            radius: ChassisTokens.ShadowContextLarge1Radius,
            x: ChassisTokens.ShadowContextLarge1OffsetX,
            y: ChassisTokens.ShadowContextLarge1OffsetY
        ),
        second: Layer(
            color: ChassisTokens.ShadowContextLarge2Color,
            radius: ChassisTokens.ShadowContextLarge2Radius,
            x: ChassisTokens.ShadowContextLarge2OffsetX,
            y: ChassisTokens.ShadowContextLarge2OffsetY
        )
    )
}

extension View {
    func chassisShadow(_ shadow: ChassisShadow) -> some View {
        self
            .shadow(
                color: .token(shadow.first.color),
                radius: shadow.first.radius,
                x: shadow.first.x,
                y: shadow.first.y
            )
            .shadow(
                color: .token(shadow.second.color),
                radius: shadow.second.radius,
                x: shadow.second.x,
                y: shadow.second.y
            )
    }
}

/// The motion of the tokens as animations. They stop when the person asks for reduced motion.
@MainActor
enum ChassisMotion {
    static var standard: Animation? {
        curve(
            ChassisTokens.MotionEasingContextEaseInAndOut,
            duration: ChassisTokens.MotionTimingContextMedium
        )
    }

    static var page: Animation? {
        curve(
            ChassisTokens.MotionEasingPageTransition,
            duration: ChassisTokens.MotionTimingPageTransition
        )
    }

    static func curve(
        _ easing: (x1: Double, y1: Double, x2: Double, y2: Double),
        duration: TimeInterval
    ) -> Animation? {
        if UIAccessibility.isReduceMotionEnabled {
            return nil
        }
        return .timingCurve(easing.x1, easing.y1, easing.x2, easing.y2, duration: duration)
    }
}

/// The native bars, styled by the tokens. They are the mobile bars of the Figma library:
/// `Mobile Bottom Navigation` and `Mobile Nav Control Bar`.
enum ChassisAppearance {
    @MainActor
    static func configure() {
        let item = UITabBarItemAppearance()
        item.normal.iconColor = ChassisTokensColor.ColorContextDefaultFgSubtle
        item.normal.titleTextAttributes = [
            .font: ChassisType.tab.uiFont,
            .foregroundColor: ChassisTokensColor.ColorContextDefaultFgSubtle
        ]
        item.selected.iconColor = ChassisTokensColor.ColorContextPrimaryBaseColor
        item.selected.titleTextAttributes = [
            .font: ChassisType.tab.uiFont,
            .foregroundColor: ChassisTokensColor.ColorContextPrimaryBaseColor
        ]

        let tabBar = UITabBarAppearance()
        tabBar.configureWithOpaqueBackground()
        tabBar.backgroundColor = ChassisTokensColor.ColorContextDefaultBgEven
        tabBar.shadowColor = ChassisTokensColor.ColorContextDefaultBorderSubtle
        tabBar.stackedLayoutAppearance = item
        tabBar.inlineLayoutAppearance = item
        tabBar.compactInlineLayoutAppearance = item
        UITabBar.appearance().standardAppearance = tabBar
        UITabBar.appearance().scrollEdgeAppearance = tabBar

        let navBar = UINavigationBarAppearance()
        navBar.configureWithOpaqueBackground()
        navBar.backgroundColor = ChassisTokensColor.ColorContextDefaultBgEven
        navBar.shadowColor = .clear
        navBar.titleTextAttributes = [
            .font: ChassisType.navTitle.uiFont,
            .foregroundColor: ChassisTokensColor.ColorContextDefaultFgMain
        ]
        navBar.largeTitleTextAttributes = [
            .font: ChassisType.h2.uiFont,
            .foregroundColor: ChassisTokensColor.ColorContextDefaultFgMain
        ]
        // Clear at the top of the content, where the screen shows through
        let navBarAtEdge = navBar.copy()
        navBarAtEdge.configureWithTransparentBackground()
        navBarAtEdge.titleTextAttributes = navBar.titleTextAttributes
        navBarAtEdge.largeTitleTextAttributes = navBar.largeTitleTextAttributes
        UINavigationBar.appearance().standardAppearance = navBar
        UINavigationBar.appearance().compactAppearance = navBar
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAtEdge

        UIPageControl.appearance().currentPageIndicatorTintColor =
            ChassisTokensColor.ColorContextPrimaryBaseColor
        UIPageControl.appearance().pageIndicatorTintColor =
            ChassisTokensColor.ColorContextDefaultFgSlight
    }
}
