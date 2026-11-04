import SwiftUI

/// The icons this app uses, by what they stand for, and the icon of `website-icons` that each one
/// draws. An icon that leaves the release fails to compile.
enum ChassisIcon: CaseIterable {
    case home, search, inbox, account, foundations, bell, heart, heartFilled, chevronRight, close,
        check, info, email, lock, eye, eyeOff, send, trash, star, moon, globe, signOut, palette,
        grid, cube, sparkles, filter

    var image: Image {
        switch self {
        case .home: Image(CxIcon.homeSolid)
        case .search: Image(CxIcon.searchSolid)
        case .inbox: Image(CxIcon.envelopeSolid)
        case .account: Image(CxIcon.userSolid)
        case .foundations: Image(CxIcon.swatchbookSolid)
        case .bell: Image(CxIcon.bellSolid)
        case .heart: Image(CxIcon.heartOutline)
        case .heartFilled: Image(CxIcon.heartSolid)
        case .chevronRight: Image(CxIcon.chevronRightSolid)
        case .close: Image(CxIcon.xmarkSolid)
        case .check: Image(CxIcon.checkSolid)
        case .info: Image(CxIcon.infoSolid)
        case .email: Image(CxIcon.envelopeOutline)
        case .lock: Image(CxIcon.lockSolid)
        case .eye: Image(CxIcon.eyeOutline)
        case .eyeOff: Image(CxIcon.eyeSlashOutline)
        case .send: Image(CxIcon.paperPlaneSolid)
        case .trash: Image(CxIcon.trashSolid)
        case .star: Image(CxIcon.starSolid)
        case .moon: Image(CxIcon.moonSolid)
        case .globe: Image(CxIcon.globeSolid)
        case .signOut: Image(CxIcon.arrowRightFromBracketSolid)
        case .palette: Image(CxIcon.paletteSolid)
        case .grid: Image(CxIcon.gridSolid)
        case .cube: Image(CxIcon.cubeSolid)
        case .sparkles: Image(CxIcon.sparklesSolid)
        case .filter: Image(CxIcon.filterSolid)
        }
    }
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
        icon.image
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}
