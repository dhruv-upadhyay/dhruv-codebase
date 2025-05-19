//
//  BannerCell.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//


import UIKit

class BannerCell: UICollectionViewCell {
    
    static let identifier = "BannerCell"

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.pinTo(contentView, safeArea: false)
        imageView.contentMode = .scaleAspectFill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with banner: String) {
        if let image = UIImage(named: banner) {
            imageView.image = image
        }
    }
}
