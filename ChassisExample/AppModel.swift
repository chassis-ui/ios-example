import SwiftUI

enum GuideCategory: String, CaseIterable, Hashable {
    case all, tokens, assets, parts

    var title: String {
        rawValue.capitalized
    }
}

struct Guide: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let body: String
    let category: GuideCategory
    let image: ChassisImage
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isMine: Bool
}

struct Thread: Identifiable, Hashable {
    let id: String
    let name: String
    var messages: [ChatMessage]
    var unread: Int
}

struct Plan: Identifiable, Hashable {
    let id: String
    let title: String
    let price: String
    let features: [String]
}

struct Toast: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    var isError = false
}

enum AppearanceChoice: String, CaseIterable, Hashable {
    case system, light, dark

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

/// What the screens share. A real app would read it from a server.
@MainActor
@Observable
final class AppModel {
    var saved: Set<Guide.ID> = []
    var threads = SampleData.threads
    var plan = SampleData.plans[0]
    var toast: Toast?

    var unreadCount: Int {
        threads.reduce(0) { $0 + $1.unread }
    }

    func toggleSaved(_ guide: Guide) {
        if saved.remove(guide.id) == nil {
            saved.insert(guide.id)
            show(Toast(title: "Saved", message: "\(guide.title) is in your saved guides."))
        }
    }

    func show(_ newToast: Toast) {
        withAnimation(ChassisMotion.standard) {
            toast = newToast
        }
        Task {
            try? await Task.sleep(for: .seconds(ChassisTokens.MotionTimingCarouselDuration))
            if toast == newToast {
                withAnimation(ChassisMotion.standard) {
                    toast = nil
                }
            }
        }
    }

    func send(_ text: String, to threadID: Thread.ID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].messages.append(ChatMessage(text: text, isMine: true))
    }

    func markRead(_ threadID: Thread.ID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].unread = 0
    }

    func delete(_ threadID: Thread.ID) {
        threads.removeAll { $0.id == threadID }
    }
}

/// The content of the example, which says the same in every brand.
enum SampleData {
    static let guides = [
        Guide(
            id: "tokens",
            title: "Design tokens",
            summary: "One set of decisions, written for every platform.",
            body: "Colors, type, spacing and motion come from one release. This app pins its version, so a new release is a one-line change that shows up as a clear diff.",
            category: .tokens,
            image: .tokens
        ),
        Guide(
            id: "library",
            title: "The Figma library",
            summary: "Components that designers and this code both read.",
            body: "The bars of this app follow the mobile navigation of the Figma library, and take the tokens that its pages list.",
            category: .parts,
            image: .library
        ),
        Guide(
            id: "gallery",
            title: "Component gallery",
            summary: "Buttons, fields and cards in all their states.",
            body: "Each component takes its colors, sizes and fonts from tokens. Where the tokens have no group for it, it takes the closest context or unit token.",
            category: .parts,
            image: .gallery
        ),
        Guide(
            id: "platforms",
            title: "Every platform",
            summary: "The same assets, named the way each platform expects.",
            body: "An archive per platform, app and brand holds the fonts, images and icons. This app takes the iOS archive with its asset catalogs.",
            category: .assets,
            image: .platforms
        ),
        Guide(
            id: "parts",
            title: "Built from parts",
            summary: "Change the brand, and the screens stay the same.",
            body: "Nothing in the source of this app names a brand. One build setting chooses the tokens and the assets, and the code does not change.",
            category: .assets,
            image: .parts
        ),
        Guide(
            id: "docs",
            title: "Documented",
            summary: "What each part is for, and how to use it.",
            body: "This app is an example to read. The README explains how it takes its tokens and assets, and what to copy into a project.",
            category: .parts,
            image: .docs
        )
    ]

    static let threads = [
        Thread(
            id: "design",
            name: "Maya Chen",
            messages: [
                ChatMessage(text: "The new token release is out.", isMine: false),
                ChatMessage(text: "Great, I'll update the version and build.", isMine: true),
                ChatMessage(text: "Can you check the dark logo too?", isMine: false)
            ],
            unread: 1
        ),
        Thread(
            id: "review",
            name: "Sam Rivera",
            messages: [
                ChatMessage(text: "Is the pricing sheet ready for review?", isMine: false),
                ChatMessage(text: "Yes, it's on the Account tab.", isMine: true)
            ],
            unread: 0
        ),
        Thread(
            id: "support",
            name: "Alex Kim",
            messages: [
                ChatMessage(text: "Which brand does this build use?", isMine: false),
                ChatMessage(text: "Fonts look right to me now.", isMine: false)
            ],
            unread: 2
        )
    ]

    static let plans = [
        Plan(
            id: "starter",
            title: "Starter",
            price: "Free",
            features: ["One project", "Community support"]
        ),
        Plan(
            id: "team",
            title: "Team",
            price: "$12 a month",
            features: ["Unlimited projects", "Shared libraries", "Email support"]
        ),
        Plan(
            id: "business",
            title: "Business",
            price: "$29 a month",
            features: ["Everything in Team", "Single sign-on", "Priority support"]
        )
    ]
}
