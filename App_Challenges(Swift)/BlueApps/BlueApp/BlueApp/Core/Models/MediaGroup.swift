//
//  MediaGroup.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//


struct MediaGroup: Decodable {
    let banner: String
    let title: String
    let subTitle: String
    let images: [MediaItem]
}

struct MediaItem: Decodable {
    let image: String
    let title: String
    let desc: String
}
