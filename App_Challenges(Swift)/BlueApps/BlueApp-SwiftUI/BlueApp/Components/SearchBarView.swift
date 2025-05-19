//
//  SearchBarView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 20/04/25.
//


import SwiftUI

struct SearchBarView: View {
    // MARK: - Properties
    @Binding var searchText: String
    
    // MARK: - Constants
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    private let color = Constants.Colors()
    private let strings = Constants.Strings()
    
    // MARK: - View
    var body: some View {
        TextField(strings.search, text: $searchText)
            .padding(.leading, spacing.m)
            .frame(height: spacing.xxl)
            .foregroundColor(.white)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: spacing.sm)
                    .stroke(color.searchColor, lineWidth: spacing.xs)
            )
            .placeholder(when: searchText.isEmpty) {
                Text(strings.search)
                    .foregroundColor(color.searchColor)
                    .padding(.horizontal, spacing.m)
            }
    }
}

// MARK: - Placeholder Modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow { placeholder() }
            self
        }
    }
}
