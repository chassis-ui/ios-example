import SwiftUI

/// A list with swipe actions and badges, which pushes to a conversation.
struct InboxView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        NavigationStack {
            Group {
                if model.threads.isEmpty {
                    ScrollView {
                        EmptyState(
                            icon: .inbox,
                            title: "Inbox is empty",
                            message: "New messages will show up here."
                        )
                    }
                } else {
                    List(model.threads) { thread in
                        NavigationLink(value: thread.id) {
                            ListRow(title: thread.name, subtitle: thread.messages.last?.text ?? "") {
                                Avatar(name: thread.name, size: ChassisTokens.SizeListImage)
                            } trailing: {
                                if thread.unread > 0 {
                                    Badge(text: String(thread.unread))
                                        .accessibilityLabel("\(thread.unread) unread")
                                }
                            }
                        }
                        .chassisListRow()
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                model.delete(thread.id)
                            } label: {
                                Label {
                                    Text("Delete")
                                } icon: {
                                    Image(ChassisIcon.trash.rawValue)
                                }
                            }
                            .tint(.token(ChassisTokensColor.ColorContextDangerBaseColor))
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                model.markRead(thread.id)
                            } label: {
                                Label {
                                    Text("Read")
                                } icon: {
                                    Image(ChassisIcon.check.rawValue)
                                }
                            }
                            .tint(.token(ChassisTokensColor.ColorContextPrimaryBaseColor))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .chassisScreen()
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Thread.ID.self) { id in
                ChatView(threadID: id)
            }
        }
    }
}

/// A conversation in the message tokens, with a field that stays above the keyboard.
struct ChatView: View {
    @Environment(AppModel.self) private var model
    let threadID: Thread.ID
    @State private var draft = ""

    private var thread: Thread? {
        model.threads.first { $0.id == threadID }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: ChassisTokens.SpaceContextXsmall) {
                ForEach(thread?.messages ?? []) { message in
                    Bubble(message: message)
                }
            }
            .padding(ChassisTokens.SpaceContextMedium)
        }
        .defaultScrollAnchor(.bottom)
        .scrollDismissesKeyboard(.interactively)
        .background(.token(ChassisTokensColor.ColorMessageBgChat))
        .safeAreaInset(edge: .bottom, spacing: ChassisTokens.SpaceUnit0) {
            HStack(spacing: ChassisTokens.SpaceContextXsmall) {
                TextField(
                    "",
                    text: $draft,
                    prompt: Text("Message")
                        .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgSubtle)),
                    axis: .vertical
                )
                .chassisType(.bodyMedium)
                .foregroundStyle(.token(ChassisTokensColor.ColorMessageFgForm))
                .accessibilityLabel("Message")
                Button {
                    model.send(draft, to: threadID)
                    draft = ""
                } label: {
                    Icon(.send)
                }
                .disabled(draft.isEmpty)
                .accessibilityLabel("Send")
            }
            .padding(ChassisTokens.SpaceContextSmall)
            .background(.token(ChassisTokensColor.ColorMessageBgForm))
        }
        .navigationTitle(thread?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            model.markRead(threadID)
        }
    }
}

private struct Bubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isMine {
                Spacer(minLength: ChassisTokens.SizeContext2xlarge)
            }
            Text(message.text)
                .chassisType(.bodyMedium)
                .foregroundStyle(.token(
                    message.isMine
                        ? ChassisTokensColor.ColorMessageFgSent
                        : ChassisTokensColor.ColorMessageFgReceived
                ))
                .padding(.horizontal, ChassisTokens.SpaceContextSmall)
                .padding(.vertical, ChassisTokens.SpaceContextXsmall)
                .background(
                    .token(
                        message.isMine
                            ? ChassisTokensColor.ColorMessageBgSent
                            : ChassisTokensColor.ColorMessageBgReceived
                    ),
                    in: RoundedRectangle(cornerRadius: ChassisTokens.BorderRadiusContext2xlarge)
                )
            if !message.isMine {
                Spacer(minLength: ChassisTokens.SizeContext2xlarge)
            }
        }
    }
}
