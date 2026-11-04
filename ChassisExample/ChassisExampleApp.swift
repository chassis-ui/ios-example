import SwiftUI

@main
struct ChassisExampleApp: App {
    init() {
        ChassisFonts.register()
        ChassisAppearance.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Sign-in first, then the tabs. The choice of appearance applies to both.
struct RootView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("appearance") private var appearance = AppearanceChoice.system
    @State private var model = AppModel()

    var body: some View {
        Group {
            if isSignedIn {
                MainTabs()
            } else {
                OnboardingView()
            }
        }
        .environment(model)
        .tint(.token(ChassisTokensColor.ColorContextDefaultIconMain))
        .preferredColorScheme(appearance.colorScheme)
        .overlay(alignment: .top) {
            if let toast = model.toast {
                NotificationBanner(toast: toast)
                    .padding(.horizontal, ChassisTokens.SpaceContextMedium)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    // It sits over the bar for a moment, and the buttons under it keep working
                    .allowsHitTesting(false)
            }
        }
    }
}

/// `Mobile Bottom Navigation`, type tabs: the native tab bar, styled in `ChassisAppearance`.
struct MainTabs: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        TabView {
            Tab {
                HomeView()
            } label: {
                TabLabel(title: "Home", icon: .home)
            }
            Tab {
                SearchView()
            } label: {
                TabLabel(title: "Search", icon: .search)
            }
            Tab {
                InboxView()
            } label: {
                TabLabel(title: "Inbox", icon: .inbox)
            }
            .badge(model.unreadCount)
            Tab {
                AccountView()
            } label: {
                TabLabel(title: "Account", icon: .account)
            }
            Tab {
                FoundationsView()
            } label: {
                TabLabel(title: "Foundations", icon: .foundations)
            }
        }
    }
}

private struct TabLabel: View {
    let title: String
    let icon: ChassisIcon

    var body: some View {
        Label {
            Text(title)
        } icon: {
            icon.image
        }
    }
}
