//
//  HomeUIModel.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import Foundation

/// Home screen UI data model
struct HomeUIModel {
    var banner: [BannerUIModel]
    var images: [ImageUIModel]
}

/// Home screen images UI data model
struct ImageUIModel: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var description: String
}

/// Home screen banner UI data model
struct BannerUIModel: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var subtitle: String
}

/// Frequency popup screen UI data model
struct FrequencyUIModel {
    let title: String
    let totalItems: Int
    let charCounts: [FrequencyCountUIModel]
}

/// Frequency popup screen UI count data model
struct FrequencyCountUIModel {
    let char: String
    let count: Int
}
