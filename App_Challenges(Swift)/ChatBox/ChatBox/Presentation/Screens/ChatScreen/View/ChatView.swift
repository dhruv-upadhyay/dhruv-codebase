//
//  ChatView.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 25/04/25.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ChatViewModel
    
    // MARK: - MainView
    var body: some View {
        VStack {
            /// Navbar
            navBar
            
            /// No internet connectoin view
            if !viewModel.isConnectedToNetwork {
                NoInternetConnectionView()
            }
            
            /// Chat area view
            chatArea
            
            /// Textfield
            textfield
        }
        .onAppear {
            viewModel.markMessagesAsRead()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - NavBar
    var navBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                viewModel.images.backImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: viewModel.spacing.large)
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.leading)
            }
            .padding(.top, viewModel.spacing.small)
            Spacer()
        }
        .overlay {
            Text(viewModel.strings.chat)
                .font(.title)
                .bold()
        }
        .padding(.top)
    }
    
    // MARK: - Chat area
    var chatArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: viewModel.spacing.medium) {
                    ForEach(viewModel.messages) { message in
                        VStack(alignment: message.isUser ? .trailing : .leading, spacing: viewModel.spacing.small) {
                            if message.id == viewModel.chatSession.lastReadMessageID {
                                Text("\(viewModel.unreadCount) \(viewModel.strings.unreadMessages)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, viewModel.spacing.small)
                            }
                            
                            Text(message.content)
                                .font(.body)
                                .foregroundColor(message.isUser ? .white : .black)
                                .padding(.horizontal, viewModel.spacing.extraSmall)
                                .padding(.vertical, viewModel.spacing.small)
                                .background(message.isUser ? Color.black : Color.backgroundEFEFEF)
                                .clipShape(ChatBubbleShape(isCurrentUser: message.isUser, cornerSize: viewModel.spacing.regular))
                                .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
                        }
                        .padding(.horizontal)
                        .id(message.id)
                    }
                }
                .padding(.top)
            }
            .onChange(of: viewModel.messages.count, {
                if let last = viewModel.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            })
            .onAppear {
                viewModel.isChatScreen = true
                if let last = viewModel.messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
            .onDisappear {
                viewModel.updateOnBack()
            }
        } /// Chat view
    }
    
    // MARK: - TextField
    var textfield: some View {
        HStack {
            TextField(viewModel.strings.placeholderText, text: $viewModel.inputText)
                .padding(.horizontal, viewModel.spacing.extraSmall)
                .frame(height: viewModel.spacing.jumbo)
            
            Button {
                viewModel.sendMessage()
            } label: {
                viewModel.images.sendImage
                    .resizable()
                    .frame(width: viewModel.spacing.regular, height: viewModel.spacing.regular)
                    .foregroundStyle(.black)
            }
            .padding(.trailing, viewModel.spacing.regular)
        }
        .background(Color.backgroundEFEFEF)
        .clipShape(Capsule())
        .padding()
    }
    
    // MARK: - Chat Bubble
    struct ChatBubbleShape: Shape {
        var isCurrentUser: Bool
        var cornerSize: CGFloat
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: isCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight],
                cornerRadii: CGSize(width: cornerSize, height: cornerSize)
            )
            return Path(path.cgPath)
        }
    }
}
