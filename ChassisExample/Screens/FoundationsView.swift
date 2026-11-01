import SwiftUI

/// The tokens and assets of the brand of this build, to look at and compare between brands.
struct FoundationsView: View {
    private enum Topic: String, CaseIterable, Identifiable {
        case colors = "Colors"
        case typography = "Typography"
        case spacing = "Spacing"
        case radius = "Radius"
        case shadows = "Shadows"
        case motion = "Motion"
        case icons = "Icons"
        case components = "Components"

        var id: Self { self }

        var icon: ChassisIcon {
            switch self {
            case .colors: .palette
            case .typography: .sparkles
            case .spacing: .grid
            case .radius: .cube
            case .shadows: .moon
            case .motion: .globe
            case .icons: .star
            case .components: .filter
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(Topic.allCases) { topic in
                NavigationLink(value: topic) {
                    ListRow(title: topic.rawValue) {
                        Icon(topic.icon, size: ChassisTokens.SizeListIcon)
                    } trailing: {
                        EmptyView()
                    }
                }
                .chassisListRow()
            }
            .listStyle(.plain)
            .chassisScreen()
            .navigationTitle("Foundations")
            .navigationDestination(for: Topic.self) { topic in
                detail(of: topic)
                    .navigationTitle(topic.rawValue)
                    .navigationBarTitleDisplayMode(.inline)
                    .chassisScreen()
            }
        }
    }

    @ViewBuilder
    private func detail(of topic: Topic) -> some View {
        switch topic {
        case .colors: ColorsPage()
        case .typography: TypographyPage()
        case .spacing: SpacingPage()
        case .radius: RadiusPage()
        case .shadows: ShadowsPage()
        case .motion: MotionPage()
        case .icons: IconsPage()
        case .components: ComponentsPage()
        }
    }
}

/// A name in the code font, as the token is written.
private struct TokenName: View {
    let name: String

    var body: some View {
        Text(name)
            .chassisType(.code)
            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
    }
}

private struct Page<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextMedium) {
                content
            }
            .padding(ChassisTokens.SpaceContextMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct ColorsPage: View {
    private struct Group: Identifiable {
        let name: String
        let swatches: [(String, UIColor)]
        var id: String { name }
    }

    private let groups = [
        Group(name: "Primary", swatches: [
            ("BaseColor", ChassisTokensColor.ColorContextPrimaryBaseColor),
            ("BgMain", ChassisTokensColor.ColorContextPrimaryBgMain),
            ("BgEven", ChassisTokensColor.ColorContextPrimaryBgEven),
            ("FgMain", ChassisTokensColor.ColorContextPrimaryFgMain)
        ]),
        Group(name: "Secondary", swatches: [
            ("BaseColor", ChassisTokensColor.ColorContextSecondaryBaseColor),
            ("BgMain", ChassisTokensColor.ColorContextSecondaryBgMain),
            ("BgEven", ChassisTokensColor.ColorContextSecondaryBgEven),
            ("FgMain", ChassisTokensColor.ColorContextSecondaryFgMain)
        ]),
        Group(name: "Default", swatches: [
            ("BgMain", ChassisTokensColor.ColorContextDefaultBgMain),
            ("BgEven", ChassisTokensColor.ColorContextDefaultBgEven),
            ("FgMain", ChassisTokensColor.ColorContextDefaultFgMain),
            ("FgSubtle", ChassisTokensColor.ColorContextDefaultFgSubtle)
        ]),
        Group(name: "Success", swatches: [
            ("BaseColor", ChassisTokensColor.ColorContextSuccessBaseColor),
            ("BgMain", ChassisTokensColor.ColorContextSuccessBgMain),
            ("BgEven", ChassisTokensColor.ColorContextSuccessBgEven),
            ("FgMain", ChassisTokensColor.ColorContextSuccessFgMain)
        ]),
        Group(name: "Warning", swatches: [
            ("BaseColor", ChassisTokensColor.ColorContextWarningBaseColor),
            ("BgMain", ChassisTokensColor.ColorContextWarningBgMain),
            ("BgEven", ChassisTokensColor.ColorContextWarningBgEven),
            ("FgMain", ChassisTokensColor.ColorContextWarningFgMain)
        ]),
        Group(name: "Danger", swatches: [
            ("BaseColor", ChassisTokensColor.ColorContextDangerBaseColor),
            ("BgMain", ChassisTokensColor.ColorContextDangerBgMain),
            ("BgEven", ChassisTokensColor.ColorContextDangerBgEven),
            ("FgMain", ChassisTokensColor.ColorContextDangerFgMain)
        ])
    ]

    var body: some View {
        Page {
            ForEach(groups) { group in
                SectionTitle(title: group.name)
                ForEach(group.swatches, id: \.0) { swatch in
                    HStack(spacing: ChassisTokens.SpaceContextSmall) {
                        RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusContextMedium)
                            .fill(.token(swatch.1))
                            .frame(width: ChassisTokens.SizeContextMedium, height: ChassisTokens.SizeContextMedium)
                            .overlay {
                                RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusContextMedium)
                                    .strokeBorder(
                                        .token(ChassisTokensColor.ColorContextDefaultBorderSubtle),
                                        lineWidth: ChassisTokens.BorderWidthContextMedium
                                    )
                            }
                        TokenName(name: swatch.0)
                    }
                }
            }
        }
    }
}

private struct TypographyPage: View {
    var body: some View {
        Page {
            ForEach(ChassisType.all, id: \.name) { style in
                VStack(alignment: .leading, spacing: ChassisTokens.SpaceUnit2) {
                    Text(style.type.family)
                        .chassisType(style.type)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                    TokenName(name: "\(style.name) · \(ChassisFonts.fileName(of: style.type))")
                }
            }
        }
    }
}

private struct SpacingPage: View {
    private let steps: [(String, CGFloat)] = [
        ("2xsmall", ChassisTokens.SpaceContext2xsmall),
        ("Xsmall", ChassisTokens.SpaceContextXsmall),
        ("Small", ChassisTokens.SpaceContextSmall),
        ("Medium", ChassisTokens.SpaceContextMedium),
        ("Large", ChassisTokens.SpaceContextLarge),
        ("Xlarge", ChassisTokens.SpaceContextXlarge),
        ("2xlarge", ChassisTokens.SpaceContext2xlarge)
    ]

    var body: some View {
        Page {
            ForEach(steps, id: \.0) { step in
                HStack(spacing: ChassisTokens.SpaceContextSmall) {
                    Rectangle()
                        .fill(.token(ChassisTokensColor.ColorContextPrimaryBaseColor))
                        .frame(width: step.1, height: ChassisTokens.SizeContextXsmall)
                    TokenName(name: "SpaceContext\(step.0)")
                }
            }
        }
    }
}

private struct RadiusPage: View {
    private let steps: [(String, CGFloat)] = [
        ("Small", ChassisTokens.BorderRadiusContextSmall),
        ("Medium", ChassisTokens.BorderRadiusContextMedium),
        ("Large", ChassisTokens.BorderRadiusContextLarge),
        ("Xlarge", ChassisTokens.BorderRadiusContextXlarge),
        ("2xlarge", ChassisTokens.BorderRadiusContext2xlarge),
        ("Button", ChassisTokens.BorderRadiusButtonLarge),
        ("Card", ChassisTokens.BorderRadiusCardMain)
    ]

    var body: some View {
        Page {
            ForEach(steps, id: \.0) { step in
                HStack(spacing: ChassisTokens.SpaceContextSmall) {
                    RoundedRectangle(cornerRadius: step.1)
                        .fill(.token(ChassisTokensColor.ColorContextPrimaryBgEvident))
                        .frame(width: ChassisTokens.SizeContextXlarge, height: ChassisTokens.SizeContextXlarge)
                    TokenName(name: step.0)
                }
            }
        }
    }
}

private struct ShadowsPage: View {
    private let shadows: [(String, ChassisShadow)] = [
        ("ShadowContextSmall", .small),
        ("ShadowContextMedium", .medium),
        ("ShadowContextLarge", .large),
        ("ShadowCardMain", .card)
    ]

    var body: some View {
        Page {
            ForEach(shadows, id: \.0) { shadow in
                TokenName(name: shadow.0)
                    .padding(ChassisTokens.SpaceContextLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        .token(ChassisTokensColor.ColorContextDefaultBgMain),
                        in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusCardMain)
                    )
                    .chassisShadow(shadow.1)
            }
        }
    }
}

private struct MotionPage: View {
    @State private var isMoved = false

    private let timings: [(String, TimeInterval)] = [
        ("Small", ChassisTokens.MotionTimingContextSmall),
        ("Medium", ChassisTokens.MotionTimingContextMedium),
        ("Xlarge", ChassisTokens.MotionTimingContextXlarge),
        ("3xlarge", ChassisTokens.MotionTimingContext3xlarge)
    ]

    var body: some View {
        Page {
            ForEach(timings, id: \.0) { timing in
                VStack(alignment: .leading, spacing: ChassisTokens.SpaceUnit4) {
                    TokenName(name: "MotionTimingContext\(timing.0)")
                    Circle()
                        .fill(.token(ChassisTokensColor.ColorContextPrimaryBaseColor))
                        .frame(width: ChassisTokens.SizeContextXsmall, height: ChassisTokens.SizeContextXsmall)
                        .frame(maxWidth: .infinity, alignment: isMoved ? .trailing : .leading)
                        .animation(
                            ChassisMotion.curve(
                                ChassisTokens.MotionEasingContextEaseInAndOut,
                                duration: timing.1
                            ),
                            value: isMoved
                        )
                }
            }
            Button("Play") {
                isMoved.toggle()
            }
            .buttonStyle(ChassisButtonStyle())
        }
    }
}

private struct IconsPage: View {
    private let columns = [
        GridItem(.adaptive(minimum: ChassisTokens.SizeUnit80), spacing: ChassisTokens.SpaceContextSmall)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: ChassisTokens.SpaceContextMedium) {
                ForEach(ChassisIcon.allCases, id: \.self) { icon in
                    VStack(spacing: ChassisTokens.SpaceUnit4) {
                        Icon(icon)
                            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultIconMain))
                        Text(String(describing: icon))
                            .chassisType(.labelSmall)
                            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                    }
                }
            }
            .padding(ChassisTokens.SpaceContextMedium)
        }
    }
}

private struct ComponentsPage: View {
    @State private var text = ""
    @State private var segment = GuideCategory.all
    @State private var isChipOn = true

    var body: some View {
        Page {
            SectionTitle(title: "Buttons")
            Button("Primary") {}
                .buttonStyle(ChassisButtonStyle())
            Button("Outline") {}
                .buttonStyle(ChassisButtonStyle(kind: .outline))
            Button("Danger") {}
                .buttonStyle(ChassisButtonStyle(kind: .danger))
            Button("Disabled") {}
                .buttonStyle(ChassisButtonStyle())
                .disabled(true)

            SectionTitle(title: "Selection")
            SegmentBar(options: GuideCategory.allCases.map { ($0, $0.title) }, selection: $segment)
            HStack(spacing: ChassisTokens.SpaceContextXsmall) {
                Chip(title: "Selected", isSelected: isChipOn) { isChipOn.toggle() }
                Chip(title: "Not selected", isSelected: !isChipOn) { isChipOn.toggle() }
            }

            SectionTitle(title: "Fields")
            ChassisTextField(label: "Idle", icon: .email, placeholder: "Placeholder", text: $text)
            ChassisTextField(label: "Error", icon: .email, help: "What went wrong", status: .error, text: $text)
            ChassisTextField(label: "Success", icon: .check, help: "All good", status: .success, text: $text)
            ChassisTextField(label: "Disabled", icon: .lock, placeholder: "Not now", text: $text)
                .disabled(true)

            SectionTitle(title: "Status")
            HStack(spacing: ChassisTokens.SpaceContextSmall) {
                Avatar(name: "Maya Chen")
                Badge(text: String(GuideCategory.allCases.count))
                ProgressView()
                    .tint(.token(ChassisTokensColor.ColorContextPrimaryBaseColor))
            }
            Skeleton()
            NotificationBanner(toast: Toast(title: "Done", message: "This is a notification."))
            NotificationBanner(toast: Toast(title: "Failed", message: "This one is an error.", isError: true))
        }
    }
}
