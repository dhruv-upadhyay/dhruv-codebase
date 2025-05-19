//
//  HomeViewModel.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var banners: [BannerUIModel] = []
    @Published var sectionImages: [ImageUIModel] = []
    @Published var currentSection: Int = 0
    @Published var showPopup: Bool = false
    @Published var searchQuery: String = ""
    @Published var freqData: FrequencyUIModel?
    
    private var data: [MediaGroup] = []
    private var viewData: [HomeUIModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constants
    let colors = Constants.Colors()
    let strings = Constants.Strings()
    let images = Constants.Images()
    let spacing = Constants.Spacing()
    
    // MARK: - Init
    init() {
        loadData()
        observeSearchQuery()
    }
}

// MARK: - LoadData
extension HomeViewModel {
    private func loadData() {
        data = JSONLoader.loadMediaData(from: strings.jsonFileName) ?? []
        banners.append(contentsOf: data.map {
            return BannerUIModel(image: $0.banner, title: $0.title, subtitle: $0.subTitle)
        })
        setImages()
    }
}

// MARK: - Search Functionality
extension HomeViewModel {
    private func observeSearchQuery() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchImages()
            }
            .store(in: &cancellables)
    }
    
    private func searchImages() {
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sectionImages = data.at(currentSection)?.images.map {
                return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
            } ?? []
        } else {
            sectionImages = data.at(currentSection)?.images.filter {
                $0.title.lowercased().contains(searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            }.map {
                return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
            } ?? []
        }
    }
}

// MARK: - Get Methods
extension HomeViewModel {
    private func getFreqViewData() {
        let allText = sectionImages
            .flatMap { [$0.title, $0.description] }
            .joined()
            .lowercased()
            .filter { $0.isLetter }
        
        let frequency = Dictionary(grouping: allText, by: { $0 })
            .mapValues { $0.count }
        
        let topThree = frequency
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { FrequencyCountUIModel(char: String($0.key), count: $0.value) }
        freqData = FrequencyUIModel(title: banners.at(currentSection)?.title ?? "", totalItems: sectionImages.count, charCounts: topThree)
    }
}

// MARK: - Set Methods
extension HomeViewModel {
    func setImages() {
        sectionImages = []
        sectionImages.append(contentsOf: (data.at(currentSection)?.images ?? []).map {
            return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
        })
        getFreqViewData()
    }
    
    func clearSearchQuery() {
        searchQuery = ""
    }
}
