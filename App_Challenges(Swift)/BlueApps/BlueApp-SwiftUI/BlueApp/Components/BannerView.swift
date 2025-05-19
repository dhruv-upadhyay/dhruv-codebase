//
//  BannerView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 20/04/25.
//


import SwiftUI

struct BannerView: View {
    // MARK: - Constants
    private let colors = Constants.Colors()
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    
    // MARK: - Properties
    @Binding var banners: [BannerUIModel]
    @Binding var currentIndex: Int
    
    // MARK: - View
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(Array(banners.enumerated()), id: \.element.id) { index, model in
                    if let uiImage = UIImage(named: model.image) {
                        let aspectRatio = uiImage.size.width / uiImage.size.height
                        let imageHeight = screenWidth / aspectRatio
                        
                        ZStack(alignment: .bottom) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth, height: imageHeight)
                                .clipped()
                                .padding(.bottom, spacing.extraHuge + spacing.s)
                            
                            LinearGradient(
                                gradient: Gradient(colors: [colors.primaryColor,
                                                            colors.primaryColor,
                                                            Color.clear]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: spacing.mega + spacing.ultra)
                        }
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: calculatedHeight())
            .background(colors.primaryColor)

            if banners.indices.contains(currentIndex) {
                let currentBanner = banners[currentIndex]
                
                VStack {
                    Text(currentBanner.subtitle)
                        .foregroundStyle(.white)
                        .font(.system(size: fontSize.mediumTitle, weight: .light))
                    
                    Text(currentBanner.title.uppercased())
                        .foregroundStyle(.white)
                        .font(.system(size: fontSize.largeTitle, weight: .bold))
                }
                .padding(.bottom, spacing.xxl)
                .transition(.opacity)
            }
        }
        .background(colors.primaryColor)
    }
    
    // MARK: - Height Calculation
    private func calculatedHeight() -> CGFloat {
        guard let first = banners.first,
              let uiImage = UIImage(named: first.image) else {
            return spacing.giga + spacing.giga
        }

        let screenWidth = UIScreen.main.bounds.width
        let aspectRatio = uiImage.size.width / uiImage.size.height
        return (screenWidth / aspectRatio) + spacing.extraHuge + spacing.s
    }
}
