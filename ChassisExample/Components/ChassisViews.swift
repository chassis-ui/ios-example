import SwiftUI

/// A filter chip of the chip tokens.
struct Chip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .chassisType(.chip)
                .lineLimit(1)
                .foregroundStyle(.token(
                    isSelected
                        ? ChassisTokensColor.ColorContextPrimaryFgMain
                        : ChassisTokensColor.ColorContextDefaultFgMain
                ))
                .padding(.horizontal, ChassisTokens.SpaceChipMediumGap)
                .padding(.vertical, ChassisTokens.SpaceChipMediumPaddingY)
                .frame(minHeight: ChassisTokens.SizeChipMediumMain)
                .background(
                    .token(
                        isSelected
                            ? ChassisTokensColor.ColorContextPrimaryBgEven
                            : ChassisTokensColor.ColorContextDefaultBgMain
                    ),
                    in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusChipMedium)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusChipMedium)
                        .strokeBorder(
                            .token(
                                isSelected
                                    ? ChassisTokensColor.ColorContextPrimaryBorderMain
                                    : ChassisTokensColor.ColorContextDefaultBorderSubtle
                            ),
                            lineWidth: ChassisTokens.BorderWidthContextMedium
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// A count of the badge tokens.
struct Badge: View {
    let text: String

    var body: some View {
        Text(text)
            .chassisType(.badge)
            .foregroundStyle(.token(ChassisTokensColor.ColorContextDangerContrastColor))
            .padding(.horizontal, ChassisTokens.SpaceBadgeSmallNudge)
            .frame(minWidth: ChassisTokens.SizeBadgeSmallMain, minHeight: ChassisTokens.SizeBadgeSmallMain)
            .background(
                .token(ChassisTokensColor.ColorContextDangerBaseColor),
                in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusBadgeSmall)
            )
    }
}

/// The initials of a person. The tokens have no avatar group, so this takes context tokens.
struct Avatar: View {
    let name: String
    var size: CGFloat = ChassisTokens.SizeContextMedium

    var body: some View {
        Text(name.split(separator: " ").compactMap(\.first).prefix(2).map(String.init).joined())
            .chassisType(size > ChassisTokens.SizeContextMedium ? .h4 : .labelMedium)
            // The circle has a fixed size, and the initials stay inside it
            .dynamicTypeSize(...DynamicTypeSize.large)
            .foregroundStyle(.token(ChassisTokensColor.ColorContextPrimaryFgMain))
            .frame(width: size, height: size)
            .background(.token(ChassisTokensColor.ColorContextPrimaryBgEvident), in: Circle())
            .accessibilityHidden(true)
    }
}

/// A placeholder while content loads. It pulses at the timing of the skeleton tokens.
struct Skeleton: View {
    var height: CGFloat = ChassisTokens.SizeContextXsmall
    @State private var isDimmed = false

    var body: some View {
        RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusContextMedium)
            .fill(.token(ChassisTokensColor.ColorContextDefaultDimSubtle))
            .frame(height: height)
            // Scoped to this value, so that the pulse never reaches the removal of the view
            .opacity(isDimmed ? ChassisTokens.OpacityLevel40 : 1)
            .animation(
                ChassisMotion.curve(
                    ChassisTokens.MotionEasingSkeletonTransition,
                    duration: ChassisTokens.MotionTimingSkeletonTransition
                )?.repeatForever(autoreverses: true),
                value: isDimmed
            )
            .accessibilityHidden(true)
            .onAppear {
                isDimmed = true
            }
    }
}

/// A message of the notification tokens. As a toast it sits above the content for a moment.
struct NotificationBanner: View {
    let toast: Toast

    var body: some View {
        HStack(alignment: .top, spacing: ChassisTokens.SpaceNotificationGap) {
            Icon(toast.isError ? .info : .check, size: ChassisTokens.SizeNotificationIcon)
                .foregroundStyle(.token(
                    toast.isError
                        ? ChassisTokensColor.ColorContextDangerIconMain
                        : ChassisTokensColor.ColorContextSuccessIconMain
                ))
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceUnit2) {
                Text(toast.title)
                    .chassisType(.notificationTitle)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                Text(toast.message)
                    .chassisType(.notificationMessage)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
            }
            Spacer(minLength: ChassisTokens.SpaceUnit0)
        }
        .padding(.horizontal, ChassisTokens.SpaceNotificationPaddingX)
        .padding(.vertical, ChassisTokens.SpaceNotificationPaddingY)
        .background(
            .token(ChassisTokensColor.ColorContextDefaultBgMain),
            in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusNotificationMain)
        )
        .overlay {
            RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusNotificationMain)
                .strokeBorder(
                    .token(ChassisTokensColor.ColorContextDefaultBorderSubtle),
                    lineWidth: ChassisTokens.BorderWidthContextMedium
                )
        }
        .chassisShadow(.medium)
        .accessibilityElement(children: .combine)
    }
}

/// A card of the card tokens, with an image of the assets.
struct GuideCard: View {
    let guide: Guide

    var body: some View {
        VStack(alignment: .leading, spacing: ChassisTokens.SpaceUnit0) {
            Image(guide.image.rawValue)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .background(.token(ChassisTokensColor.ColorContextDefaultBgEven))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContext2xsmall) {
                Text(guide.category.title)
                    .chassisType(.cardSubtitle)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextPrimaryFgMain))
                Text(guide.title)
                    .chassisType(.cardTitle)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                Text(guide.summary)
                    .chassisType(.cardBody)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                    .multilineTextAlignment(.leading)
            }
            .padding(ChassisTokens.SpaceContextMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.token(ChassisTokensColor.ColorContextDefaultBgMain))
        .clipShape(RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusCardMain))
        .chassisShadow(.card)
    }
}

/// A row of the list tokens: an icon or an avatar, its text, and what the row ends with.
struct ListRow<Leading: View, Trailing: View>: View {
    let title: String
    var subtitle = ""
    @ViewBuilder let leading: Leading
    @ViewBuilder let trailing: Trailing

    var body: some View {
        HStack(spacing: ChassisTokens.SpaceListGap) {
            leading
                .foregroundStyle(.token(ChassisTokensColor.ColorListIcon))
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceUnit0) {
                Text(title)
                    .chassisType(.labelLarge)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .chassisType(.bodySmall)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                        .lineLimit(1)
                }
            }
            Spacer(minLength: ChassisTokens.SpaceUnit0)
            trailing
        }
        .contentShape(Rectangle())
    }
}

/// What a row with a destination ends with.
struct Disclosure: View {
    var body: some View {
        Icon(.chevronRight, size: ChassisTokens.SizeIconGlyphXsmall)
            .foregroundStyle(.token(ChassisTokensColor.ColorListDisclosure))
    }
}

extension View {
    /// A `List` row with the padding and the colors of the list tokens.
    func chassisListRow() -> some View {
        self
            .listRowInsets(EdgeInsets(
                top: ChassisTokens.SpaceListPaddingY,
                leading: ChassisTokens.SpaceListPaddingX,
                bottom: ChassisTokens.SpaceListPaddingY,
                trailing: ChassisTokens.SpaceListPaddingX
            ))
            .listRowBackground(Color.token(ChassisTokensColor.ColorContextDefaultBgMain))
            .listRowSeparatorTint(.token(ChassisTokensColor.ColorContextDefaultBorderSubtle))
    }

    /// A `List` or a screen on the page color of the tokens.
    func chassisScreen() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(.token(ChassisTokensColor.ColorContextDefaultBgEven))
    }
}

/// A heading above a list section, in the section tokens.
struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .chassisType(.sectionHeader)
            .foregroundStyle(.token(ChassisTokensColor.ColorSectionFgMedium))
            .textCase(nil)
    }
}

/// What a list shows with nothing in it.
struct EmptyState: View {
    let icon: ChassisIcon
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: ChassisTokens.SpaceContextXsmall) {
            Icon(icon, size: ChassisTokens.SizeIconGlyph3xlarge)
                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultIconSlight))
            Text(title)
                .chassisType(.titleSmall)
                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
            Text(message)
                .chassisType(.bodySmall)
                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                .multilineTextAlignment(.center)
        }
        .padding(ChassisTokens.SpacePageMediumPaddingX)
        .frame(maxWidth: .infinity)
    }
}
