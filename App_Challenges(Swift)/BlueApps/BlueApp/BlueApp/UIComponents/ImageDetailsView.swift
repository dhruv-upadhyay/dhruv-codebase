//
//  ImageDetailsView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import UIKit

class ImageDetailsView: UIView {
    // MARK: - UIComponents
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let innerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Constants
    private let colors = Constants.Colors()
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setTheme() {
        backgroundColor = colors.primaryColor
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = spacing.md
            $0.alignment = .leading
            $0.distribution = .fill
        }
        
        innerStackView.do {
            $0.axis = .vertical
            $0.spacing = spacing.xxs
            $0.alignment = .leading
            $0.distribution = .fill
        }
        
        titleLabel.do {
            $0.textColor = .white
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: spacing.lg, weight: .regular)
        }
        
        descriptionLabel.do {
            $0.textColor = colors.lightGray
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: fontSize.body, weight: .light)
            $0.numberOfLines = .zero
        }
        
        imageView.contentMode = .scaleAspectFill
    }
    
    private func doLayout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(innerStackView)
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(descriptionLabel)
        
        addSubviews(stackView)
        stackView.pinTo(self, insets: UIEdgeInsets(top: spacing.sm, left: spacing.ml, bottom: spacing.sm, right: spacing.ml))
        
        imageView.constrain([
            .width(constant: spacing.mega),
            .height(constant: spacing.huge)
        ])
    }
    
    // MARK: - Config data
    func configure(model: ImageUIModel) {
        imageView.image = UIImage(named: model.image)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
