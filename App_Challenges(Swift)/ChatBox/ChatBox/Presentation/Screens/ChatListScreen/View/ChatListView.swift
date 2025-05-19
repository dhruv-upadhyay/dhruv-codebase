//
//  ChatListView.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import SwiftUI

struct ChatListView: View {
    // MARK: - Properties
    @StateObject var viewModel = ChatListViewModel()
    @State private var selectedSession: ChatViewModel? = nil
    @State private var navigationPath = NavigationPath()

    // MARK: - Main view
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                navBar /// Navbar view
                
                /// No internet connectoin view
                if !viewModel.isConnectedToNetwork {
                    NoInternetConnectionView()
                }
                
                /// Chats List
                if viewModel.chatSessions.count > .zero {
                    ScrollView {
                        VStack(spacing: viewModel.spacing.medium) {
                            ForEach(viewModel.chatSessions, id: \.roomID) { session in
                                Button(action: {
                                    selectedSession = session
                                    navigationPath.append(session)
                                }) {
                                    ChatSessionRowView(
                                        title: viewModel.title(for: session),
                                        lastMessage: session.messages.last?.content, viewModel: viewModel, isUnread: session.chatSession.isUnread, unreadCount: session.chatSession.unreadCount
                                    )
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: viewModel.spacing.medium)
                                            .fill(Color.backgroundF7F7F8)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                } else {
                    noDataView /// If there is no chat then `No data view`.
                }
            }
            .navigationDestination(for: ChatViewModel.self) { session in
                ChatView(viewModel: session) /// Redirect to next screen
            }
            .onAppear {
                viewModel.cleanEmptySessions() /// After createing a new chat if there is nothing happend then will remove that chat session.
            }
        }
    }
    
    // MARK: - Navbar View
    var navBar: some View {
        HStack {
            Spacer()
            Button(action: {
                let newSession = viewModel.createNewChat()
                selectedSession = newSession
                navigationPath.append(newSession)
            }, label: {
                viewModel.images.plusImage
                    .resizable()
                    .frame(width: viewModel.spacing.regular, height: viewModel.spacing.regular)
                    .bold()
                    .foregroundStyle(.black)
            })
            .padding(.trailing, viewModel.spacing.large)
            .padding(.bottom)
        }
        .overlay {
            Text(viewModel.strings.appTitle)
                .font(.title)
                .bold()
                .padding([.bottom], viewModel.spacing.medium)
        }
        .padding(.top)
    }
    
    // MARK: - No data view
    var noDataView: some View {
        VStack(spacing: viewModel.spacing.verySmall) {
            Image(.icNew)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, viewModel.spacing.large)
            Text(viewModel.strings.startNewChatMessage)
                .font(.system(size: viewModel.spacing.extraLarge, weight: .semibold))
            Text(viewModel.strings.descMessage)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .font(.system(size: viewModel.spacing.regular))
                .padding(.horizontal, viewModel.spacing.large)
        }
        .padding(.bottom, viewModel.spacing.huge)
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Chat session row
    struct ChatSessionRowView: View {
        let title: String
        let lastMessage: String?
        let viewModel: ChatListViewModel
        let isUnread: Bool
        let unreadCount: Int

        var body: some View {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: viewModel.spacing.verySmall) {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let lastMessage = lastMessage {
                        Text(lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity)
                if isUnread {
                    Text("\(unreadCount)")
                        .font(.caption)
                        .padding(viewModel.spacing.small)
                        .background(Color.black)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .padding(.trailing, viewModel.spacing.small)
                }
            }
        }
    }
}

// MARK: - Preview
struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
