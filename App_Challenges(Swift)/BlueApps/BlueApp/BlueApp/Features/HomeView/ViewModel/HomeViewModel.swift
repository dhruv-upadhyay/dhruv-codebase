//
//  HomeViewModel.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

class HomeViewModel {
    
    // MARK: - Enums
    enum Section: Int {
        case banner
        case list
    }
    
    struct CharacterStat {
        let character: Character
        let count: Int
    }
    
    // MARK: - Properties
    private var data: [MediaGroup] = []
    private var viewData: [HomeUIModel] = []
    private var banners: [BannerUIModel] = []
    private var sectionImages: [ImageUIModel] = []
    private var currentSection: Int = 0
    private var currentBannerIndex: Int = 0
    
    let colors = Constants.Colors()
    let strings = Constants.Strings()
    let images = Constants.Images()
    let spacing = Constants.Spacing()
}

// MARK: - LoadData
extension HomeViewModel {
    func loadData(completion: () -> Void) {
        data = JSONLoader.loadMediaData(from: strings.jsonFileName) ?? []
        banners.append(contentsOf: data.map {
            return BannerUIModel(image: $0.banner, title: $0.title, subtitle: $0.subTitle)
        })
        setImages(for: 0)
        completion()
    }
}

// MARK: - Search Functionality
extension HomeViewModel {
    func searchImages(query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sectionImages = data.at(currentSection)?.images.map {
                return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
            } ?? []
        } else {
            sectionImages = data.at(currentSection)?.images.filter {
                $0.title.lowercased().contains(query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) ||
                $0.desc.lowercased().contains(query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            }.map {
                return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
            } ?? []
        }
    }
}

// MARK: - Get methods
extension HomeViewModel {
    func getSection(section: Int) -> Section? {
        return Section(rawValue: section)
    }
    
    func getSectionCount() -> Int {
        return Section.list.rawValue + 1
    }
    
    func getCellCount(section: Int) -> Int {
        switch Section(rawValue: section) {
        case .banner:
            return 1
        default:
            return sectionImages.count
        }
    }
    
    func getBanners() -> [BannerUIModel] {
        return banners
    }
    
    func selectedSection() -> Int {
        return currentSection
    }
    
    func getImage(at index: Int) -> ImageUIModel? {
        return sectionImages.at(index)
    }
    
    func getCurrentBannerIndex() -> Int {
        return currentBannerIndex
    }
    
    func getFreqViewData() -> FrequencyUIModel {
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
        
        return FrequencyUIModel(title: banners.at(currentSection)?.title ?? "", totalItems: sectionImages.count, charCounts: topThree)
    }
    
    func getSectionIndex(from section: Section) -> Int {
        return section.rawValue
    }
}

// MARK: - Set Methods
extension HomeViewModel {
    func setImages(for section: Int) {
        currentSection = section
        sectionImages = []
        sectionImages.append(contentsOf: (data.at(section)?.images ?? []).map {
            return ImageUIModel(image: $0.image, title: $0.title, description: $0.desc)
        })
    }

    func setCurrentBannerIndex(_ index: Int) {
        currentBannerIndex = index
    }
}
