//
//  HomeView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 19/04/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var isBannerVisible: Bool = true
    
    private var safeAreaTopInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
            .first ?? .zero
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section {
                        BannerView(banners: $viewModel.banners, currentIndex: $viewModel.currentSection)
                            .onChange(of: viewModel.currentSection) { _ in
                                viewModel.setImages()
                                viewModel.clearSearchQuery()
                            }
                    }
                    
                    Section(header: searchView) {
                        ForEach(Array($viewModel.sectionImages.enumerated()), id: \.element.id) { idx, model in
                            ImageDetailsView(model: model)
                                .padding(.top, idx == .zero ? viewModel.spacing.xxl : .zero)
                                .padding(.horizontal, viewModel.spacing.ml)
                        }
                    }
                }
            }
            .allowsHitTesting(!viewModel.showPopup)
            .coordinateSpace(name: "scroll")
            .background(viewModel.colors.primaryColor)
            .ignoresSafeArea(edges: .top)
            
            HStack {
                Spacer()
                Button {
                    viewModel.showPopup.toggle()
                } label: {
                    Image(.icButton)
                }
                .frame(width: viewModel.spacing.xxl, height: viewModel.spacing.xxl)
                .padding([.trailing, .bottom], viewModel.spacing.ml)
            }
            
            if viewModel.showPopup {
                if let model = viewModel.freqData {
                    FrequencySummaryView(model: model, onClose: {
                        viewModel.showPopup.toggle()
                    })
                }
            }
        }
    }
    
    var searchView: some View {
        GeometryReader { geo in
            SearchBarView(searchText: $viewModel.searchQuery)
                .padding(.top, isBannerVisible ? .zero : safeAreaTopInset)
                .padding(.horizontal, viewModel.spacing.ml)
                .padding(.bottom, viewModel.spacing.ml)
                .background(viewModel.colors.primaryColor)
                .onChange(of: geo.frame(in: .named("scroll")).minY) { y in
                    if y < viewModel.spacing.giga {
                        isBannerVisible = false
                    } else {
                        isBannerVisible = true
                    }
                }
        }
    }
}

#Preview {
    HomeView()
}
