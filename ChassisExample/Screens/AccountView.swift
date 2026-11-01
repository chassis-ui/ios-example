import SwiftUI

/// Settings: a profile, a toggle, a sheet, a choice of appearance and a confirmation.
struct AccountView: View {
    @Environment(AppModel.self) private var model
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("appearance") private var appearance = AppearanceChoice.system
    @AppStorage("notificationsOn") private var notificationsOn = true
    @State private var isPricingShown = false
    @State private var isSignOutShown = false

    private let name = "Jordan Lee"

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ListRow(title: name, subtitle: "\(model.plan.title) plan") {
                        Avatar(name: name, size: ChassisTokens.SizeContextLarge)
                    } trailing: {
                        EmptyView()
                    }
                    .chassisListRow()
                }

                Section {
                    VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextXsmall) {
                        Text("Appearance")
                            .chassisType(.labelLarge)
                            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                        SegmentBar(
                            options: AppearanceChoice.allCases.map { ($0, $0.rawValue.capitalized) },
                            selection: $appearance
                        )
                    }
                    .chassisListRow()

                    Toggle(isOn: $notificationsOn) {
                        ListRow(title: "Notifications") {
                            Icon(.bell, size: ChassisTokens.SizeListIcon)
                        } trailing: {
                            EmptyView()
                        }
                    }
                    .tint(.token(ChassisTokensColor.ColorContextPrimaryBaseColor))
                    .chassisListRow()
                } header: {
                    SectionTitle(title: "Preferences")
                }

                Section {
                    Button {
                        isPricingShown = true
                    } label: {
                        ListRow(title: "Plan", subtitle: model.plan.price) {
                            Icon(.star, size: ChassisTokens.SizeListIcon)
                        } trailing: {
                            Disclosure()
                        }
                    }
                    .buttonStyle(.plain)
                    .chassisListRow()

                    Button {
                        isSignOutShown = true
                    } label: {
                        ListRow(title: "Sign out") {
                            Icon(.signOut, size: ChassisTokens.SizeListIcon)
                        } trailing: {
                            EmptyView()
                        }
                    }
                    .buttonStyle(.plain)
                    .chassisListRow()
                } header: {
                    SectionTitle(title: "Account")
                }
            }
            .listStyle(.insetGrouped)
            .chassisScreen()
            .navigationTitle("Account")
            .sheet(isPresented: $isPricingShown) {
                PricingSheet()
            }
            .confirmationDialog("Sign out?", isPresented: $isSignOutShown, titleVisibility: .visible) {
                Button("Sign out", role: .destructive) {
                    isSignedIn = false
                }
            }
        }
    }
}

/// A sheet with detents, the plans to pick from and an `Action Bar`.
struct PricingSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var selected = SampleData.plans[0]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: ChassisTokens.SpaceModalMediumGap) {
                    ForEach(SampleData.plans) { plan in
                        PlanCard(plan: plan, isSelected: plan == selected) {
                            selected = plan
                        }
                    }
                }
                .padding(ChassisTokens.SpaceModalMediumPaddingX)
            }
            .background(.token(ChassisTokensColor.ColorContextDefaultBgMain))
            .navigationTitle("Choose a plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Icon(.close)
                    }
                    .accessibilityLabel("Close")
                }
            }
            .safeAreaInset(edge: .bottom) {
                ActionBar {
                    Button("Choose \(selected.title)") {
                        model.plan = selected
                        model.show(Toast(
                            title: "Plan changed",
                            message: "You are on the \(selected.title) plan."
                        ))
                        dismiss()
                    }
                    .buttonStyle(ChassisButtonStyle())
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(ChassisTokens.BorderRadiusModalMain)
        .presentationBackground(.token(ChassisTokensColor.ColorContextDefaultBgMain))
        .onAppear {
            selected = model.plan
        }
    }
}

private struct PlanCard: View {
    let plan: Plan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextXsmall) {
                HStack {
                    Text(plan.title)
                        .chassisType(.cardTitle)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                    Spacer(minLength: ChassisTokens.SpaceUnit0)
                    Text(plan.price)
                        .chassisType(.cardSubtitle)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                }
                ForEach(plan.features, id: \.self) { feature in
                    HStack(spacing: ChassisTokens.SpaceContextXsmall) {
                        Icon(.check, size: ChassisTokens.SizeIconGlyphXsmall)
                            .foregroundStyle(.token(ChassisTokensColor.ColorContextSuccessIconMain))
                        Text(feature)
                            .chassisType(.cardBody)
                            .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                    }
                }
            }
            .padding(ChassisTokens.SpaceContextMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .token(
                    isSelected
                        ? ChassisTokensColor.ColorContextPrimaryBgEven
                        : ChassisTokensColor.ColorContextDefaultBgMain
                ),
                in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusCardMain)
            )
            .overlay {
                RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusCardMain)
                    .strokeBorder(
                        .token(
                            isSelected
                                ? ChassisTokensColor.ColorContextPrimaryBorderMain
                                : ChassisTokensColor.ColorContextDefaultBorderSubtle
                        ),
                        lineWidth: isSelected
                            ? ChassisTokens.BorderWidthContextXlarge
                            : ChassisTokens.BorderWidthContextMedium
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
