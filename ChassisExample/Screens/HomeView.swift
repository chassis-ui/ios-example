import SwiftUI

/// A feed: a filter, a loading state, pull to refresh, and a push to a detail screen.
struct HomeView: View {
    @Environment(AppModel.self) private var model
    @State private var category = GuideCategory.all
    @State private var isLoading = true

    private var guides: [Guide] {
        SampleData.guides.filter { category == .all || $0.category == category }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: ChassisTokens.SpaceContextMedium) {
                    if isLoading {
                        // Ids of their own: a lazy stack keeps a view of the same id as a card
                        ForEach(0 ..< 2, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextXsmall) {
                                Skeleton(height: ChassisTokens.SizeUnit160)
                                Skeleton()
                                Skeleton()
                            }
                        }
                    } else {
                        ForEach(guides) { guide in
                            NavigationLink(value: guide) {
                                GuideCard(guide: guide)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(ChassisTokens.SpaceContextMedium)
            }
            .safeAreaInset(edge: .top, spacing: ChassisTokens.SpaceUnit0) {
                SegmentBar(
                    options: GuideCategory.allCases.map { ($0, $0.title) },
                    selection: $category
                )
                .padding(.horizontal, ChassisTokens.SpaceContextMedium)
                .padding(.bottom, ChassisTokens.SpaceUnit10)
                .background(.token(ChassisTokensColor.ColorContextDefaultBgEven))
            }
            .refreshable {
                await load()
            }
            .task {
                if isLoading {
                    await load()
                }
            }
            .chassisScreen()
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Guide.self) { guide in
                GuideDetailView(guide: guide)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.show(Toast(
                            title: "Nothing new",
                            message: "You have read every announcement."
                        ))
                    } label: {
                        Icon(.bell)
                    }
                    .accessibilityLabel("Announcements")
                }
            }
        }
    }

    private func load() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(ChassisTokens.MotionTimingContext3xlarge))
        withAnimation(ChassisMotion.standard) {
            isLoading = false
        }
    }
}

/// A pushed screen, with a save action in the bar and an `Action Bar` at the bottom.
struct GuideDetailView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let guide: Guide

    var body: some View {
        let isSaved = model.saved.contains(guide.id)
        ScrollView {
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextMedium) {
                Image(guide.image.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(.token(ChassisTokensColor.ColorContextDefaultBgEven))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextXsmall) {
                    Text(guide.title)
                        .chassisType(.h2)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                    Text(guide.summary)
                        .chassisType(.lead)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                    Text(guide.body)
                        .chassisType(.bodyMedium)
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                }
                .padding(.horizontal, ChassisTokens.SpaceContextMedium)
            }
        }
        .background(.token(ChassisTokensColor.ColorContextDefaultBgMain))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    model.toggleSaved(guide)
                } label: {
                    Icon(isSaved ? .heartFilled : .heart)
                }
                .accessibilityLabel(isSaved ? "Remove from saved" : "Save")
            }
        }
        .safeAreaInset(edge: .bottom) {
            ActionBar {
                Button("Back") {
                    dismiss()
                }
                .buttonStyle(ChassisButtonStyle(kind: .outline))
                Button(isSaved ? "Saved" : "Save") {
                    model.toggleSaved(guide)
                }
                .buttonStyle(ChassisButtonStyle())
            }
        }
    }
}
