import SwiftUI

/// `Mobile Nav Search Bar` and `Mobile Nav Chip Bar` above results, with an empty state.
struct SearchView: View {
    @State private var query = ""
    @State private var category = GuideCategory.all

    private var results: [Guide] {
        SampleData.guides.filter { guide in
            (category == .all || guide.category == category)
                && (query.isEmpty
                    || guide.title.localizedCaseInsensitiveContains(query)
                    || guide.summary.localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        NavigationStack {
            // The list stays when it is empty: replacing it would take the focus from the field
            List(results) { guide in
                NavigationLink(value: guide) {
                    ListRow(title: guide.title, subtitle: guide.summary) {
                        Icon(.grid, size: ChassisTokens.SizeListIcon)
                    } trailing: {
                        EmptyView()
                    }
                }
                .chassisListRow()
            }
            .listStyle(.plain)
            .overlay(alignment: .top) {
                if results.isEmpty {
                    EmptyState(
                        icon: .search,
                        title: "No results",
                        message: "Try another word, or a different filter."
                    )
                }
            }
            .safeAreaInset(edge: .top, spacing: ChassisTokens.SpaceUnit0) {
                VStack(spacing: ChassisTokens.SpaceUnit10) {
                    SearchField(placeholder: "Search guides", text: $query)
                        .padding(.horizontal, ChassisTokens.SpaceContextMedium)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: ChassisTokens.SpaceContextXsmall) {
                            ForEach(GuideCategory.allCases, id: \.self) { option in
                                Chip(title: option.title, isSelected: option == category) {
                                    category = option
                                }
                            }
                        }
                        .padding(.horizontal, ChassisTokens.SpaceContextMedium)
                    }
                }
                .padding(.bottom, ChassisTokens.SpaceUnit10)
                // Not under the bar: on iOS 27 a background there covers a large title
                .background(.token(ChassisTokensColor.ColorContextDefaultBgEven), ignoresSafeAreaEdges: [])
            }
            .chassisScreen()
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Guide.self) { guide in
                GuideDetailView(guide: guide)
            }
        }
    }
}
