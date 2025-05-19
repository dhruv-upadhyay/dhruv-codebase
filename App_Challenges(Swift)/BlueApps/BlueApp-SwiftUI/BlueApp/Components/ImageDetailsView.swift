//
//  ImageDetailsView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 20/04/25.
//


import SwiftUI

struct ImageDetailsView: View {
    // MARK: - Properties
    @Binding var model: ImageUIModel
    
    // MARK: - Constants
    private let colors = Constants.Colors()
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    
    // MARK: - Action
    var body: some View {
        HStack(spacing: spacing.md) {
            Image(model.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: spacing.mega, height: spacing.huge)
            
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(model.title)
                    .foregroundColor(.white)
                    .font(.system(size: spacing.lg, weight: .regular))
                
                Text(model.description)
                    .foregroundColor(colors.lightGray)
                    .font(.system(size: spacing.m, weight: .light))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, spacing.s)
        .background(colors.primaryColor)
    }
}

