//
//  FrequencySummaryView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 20/04/25.
//


import SwiftUI

struct FrequencySummaryView: View {
    // MARK: - Properties
    let model: FrequencyUIModel
    
    // MARK: - Constants
    private let colors = Constants.Colors()
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    private let strings = Constants.Strings()
    private let opacity = Constants.Opacity()
    private let images = Constants.Images()
    
    // MARK: - Action
    var onClose: () -> Void
    
    // MARK: - View
    var body: some View {
        VStack {
            HStack {
                Text("\(model.title) (\(model.totalItems) \(strings.times))")
                    .font(.system(size: fontSize.mediumTitle, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    onClose()
                }) {
                    images.closeIcon
                        .foregroundColor(.white)
                        .frame(width: spacing.xxl, height: spacing.xxl)
                }
            }
            .padding(.horizontal, spacing.ml)
            .padding(.top, spacing.ml)
            
            HStack {
                ForEach(model.charCounts, id: \.char) { item in
                    VStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: spacing.xxl, height: spacing.xxl)
                            .overlay(
                                Text(item.char)
                                    .font(.system(size: fontSize.title))
                                    .foregroundColor(colors.primaryColor)
                            )
                        
                        Text("\(item.count) \(strings.times)")
                            .foregroundColor(.white)
                            .font(.system(size: fontSize.mediumTitle, weight: .regular))
                    }
                    .padding(.bottom, spacing.sm)
                }
                Spacer()
            }
            .padding([.top, .horizontal], spacing.sm)
            .padding(.horizontal, spacing.ml)
        }
        .padding(.top, spacing.xl + spacing.xl)
        .padding(.bottom, spacing.lg)
        .background(LinearGradient(gradient: Gradient(colors: [
            colors.primaryColor.opacity(opacity.low),
            colors.primaryColor.opacity(opacity.heigh),
            colors.primaryColor.opacity(opacity.full)
        ]), startPoint: .top, endPoint: .bottom))
    }
}
