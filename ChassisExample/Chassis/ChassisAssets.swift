import SwiftUI

/// The icons this app uses, by their names in `Icons.xcassets`. `scripts/lint-tokens.sh` checks
/// that each one is in the catalog.
enum ChassisIcon: String, CaseIterable {
    case home = "svgs/home_solid"
    case search = "svgs/search_solid"
    case inbox = "svgs/envelope_solid"
    case account = "svgs/user_solid"
    case foundations = "svgs/swatchbook_solid"
    case bell = "svgs/bell_solid"
    case heart = "svgs/heart_outline"
    case heartFilled = "svgs/heart_solid"
    case chevronRight = "svgs/chevron_right_solid"
    case close = "svgs/xmark_solid"
    case check = "svgs/check_solid"
    case info = "svgs/info_solid"
    case email = "svgs/envelope_outline"
    case lock = "svgs/lock_solid"
    case eye = "svgs/eye_outline"
    case eyeOff = "svgs/eye_slash_outline"
    case send = "svgs/paper_plane_solid"
    case trash = "svgs/trash_solid"
    case star = "svgs/star_solid"
    case moon = "svgs/moon_solid"
    case globe = "svgs/globe_solid"
    case signOut = "svgs/arrow_right_from_bracket_solid"
    case palette = "svgs/palette_solid"
    case grid = "svgs/grid_solid"
    case cube = "svgs/cube_solid"
    case sparkles = "svgs/sparkles_solid"
    case filter = "svgs/filter_solid"
}

/// The images this app uses, by their names in `Assets.xcassets`. A pair of `_light` and `_dark`
/// files is one name, and iOS picks the appearance.
enum ChassisImage: String, CaseIterable {
    case logo = "logo/logo"
    case library = "home/figma_library"
    case tokens = "home/figma_tokens"
    case docs = "home/figma_docs"
    case gallery = "home/comp_gallery"
    case parts = "home/lego_chassis"
    case platforms = "home/platforms"
}

/// An icon of the catalog in the color of its surroundings, which grows with Dynamic Type.
struct Icon: View {
    let icon: ChassisIcon
    @ScaledMetric private var size: CGFloat

    init(_ icon: ChassisIcon, size: CGFloat = ChassisTokens.SizeIconGlyphMedium) {
        self.icon = icon
        _size = ScaledMetric(wrappedValue: size, relativeTo: .body)
    }

    var body: some View {
        Image(icon.rawValue)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}
