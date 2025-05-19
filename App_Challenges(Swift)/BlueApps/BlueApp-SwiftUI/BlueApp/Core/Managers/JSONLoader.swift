//
//  JSONLoader.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//


import Foundation

class JSONLoader {
    static func loadMediaData(from filename: String) -> [MediaGroup]? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let mediaGroups = try JSONDecoder().decode([MediaGroup].self, from: data)
            return mediaGroups
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
