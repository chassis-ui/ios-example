import SwiftUI

/// The first launch: pages to swipe, then a form.
struct OnboardingView: View {
    private struct Page: Identifiable {
        let id: Int
        let image: ChassisImage
        let title: String
        let message: String
    }

    private let pages = [
        Page(
            id: 0,
            image: .parts,
            title: "One app, any brand",
            message: "A build setting chooses the brand. The screens stay the same."
        ),
        Page(
            id: 1,
            image: .tokens,
            title: "Tokens for every value",
            message: "Colors, type, spacing and motion all come from a versioned package."
        ),
        Page(
            id: 2,
            image: .platforms,
            title: "Assets by role",
            message: "Fonts, icons and images come from a release, under the same names."
        )
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: ChassisTokens.SpacePageSmallGap) {
                Image(ChassisImage.logo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ChassisTokens.SizeContextSmall)
                    .accessibilityHidden(true)
                TabView {
                    ForEach(pages) { page in
                        VStack(spacing: ChassisTokens.SpaceContextMedium) {
                            Image(page.image.rawValue)
                                .resizable()
                                .scaledToFit()
                                .accessibilityHidden(true)
                            Text(page.title)
                                .chassisType(.h3)
                                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                            Text(page.message)
                                .chassisType(.bodyMedium)
                                .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle))
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, ChassisTokens.SpacePageSmallPaddingX)
                        .padding(.bottom, ChassisTokens.SpaceContext3xlarge)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Get started")
                }
                .buttonStyle(ChassisButtonStyle())
                .padding(.horizontal, ChassisTokens.SpacePageSmallPaddingX)
            }
            .padding(.vertical, ChassisTokens.SpacePageSmallPaddingY)
            .background(.token(ChassisTokensColor.ColorContextDefaultBgMain))
        }
    }
}

/// A form with the states of the form tokens.
struct SignInView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var hasTriedSubmit = false

    private var emailIsValid: Bool {
        email.contains("@") && email.contains(".")
    }

    private var emailStatus: ChassisTextField.Status {
        if emailIsValid { return .success }
        return hasTriedSubmit ? .error : .regular
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ChassisTokens.SpaceContextLarge) {
                Text("Sign in to continue")
                    .chassisType(.h3)
                    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
                ChassisTextField(
                    label: "Email",
                    icon: .email,
                    placeholder: "name@example.com",
                    help: emailStatus == .error ? "Enter an email address." : "",
                    status: emailStatus,
                    text: $email
                )
                .keyboardType(.emailAddress)
                .textContentType(.username)
                ChassisTextField(
                    label: "Password",
                    icon: .lock,
                    placeholder: "Any password works here",
                    help: "This example checks nothing and stores nothing.",
                    isSecure: true,
                    text: $password
                )
                .textContentType(.password)
            }
            .padding(ChassisTokens.SpacePageSmallPaddingX)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            ActionBar {
                Button("Skip") {
                    isSignedIn = true
                }
                .buttonStyle(ChassisButtonStyle(kind: .outline))
                Button("Sign in") {
                    hasTriedSubmit = true
                    if emailIsValid {
                        isSignedIn = true
                    }
                }
                .buttonStyle(ChassisButtonStyle())
            }
        }
        .background(.token(ChassisTokensColor.ColorContextDefaultBgMain))
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
    }
}
