//
//  FrequencySummaryView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 18/04/25.
//

import UIKit

class FrequencySummaryView: UIView {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let innerStackView = UIStackView()
    private let closeButton = UIButton()
    
    // MARK: - Constants
    private let colors = Constants.Colors()
    private let spacing = Constants.Spacing()
    private let opacity = Constants.Opacity()
    private let fontSize = Constants.FontSize()
    private let images = Constants.Images()
    private let offests = Constants.Offsets()
    private let strings = Constants.Strings()
    
    var closeHandler: (() -> Void)?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout method
    override func layoutSubviews() {
        super.layoutSubviews()
        let topHeight: CGFloat = spacing.xxxl
        let totalHeight = bounds.height
        let whiteStop = NSNumber(value: Float(topHeight / totalHeight))
        
        applyGradient(
            colors: [
                colors.primaryColor.withAlphaComponent(opacity.low),
                colors.primaryColor.withAlphaComponent(opacity.heigh),
                colors.primaryColor.withAlphaComponent(opacity.full)
            ],
            locations: [0.0, whiteStop],
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint: CGPoint(x: 0.5, y: 1)
        )
    }
    
    // MARK: - Setup View
    private func setTheme() {
        titleLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: fontSize.mediumTitle, weight: .semibold)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = spacing.m
            $0.alignment = .leading
            $0.distribution = .fill
        }
        
        innerStackView.do {
            $0.axis = .horizontal
            $0.spacing = spacing.md
            $0.alignment = .leading
            $0.distribution = .fill
        }
        
        closeButton.do {
            $0.setImage(images.closeIcon, for: .normal)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        }
        
        layer.shadowColor = colors.primaryColor.cgColor
        layer.shadowOpacity = Float(opacity.medium)
        layer.shadowOffset = offests.upward6
        layer.shadowRadius = spacing.xxxl
    }
    
    private func doLayout() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(innerStackView)
        
        addSubviews(stackView, closeButton)
        closeButton.constrain([
            .top(to: topAnchor, constant: spacing.ml),
            .trailing(to: trailingAnchor, constant: spacing.ml)
        ])
        stackView.constrain([
            .top(to: topAnchor, constant: spacing.huge),
            .bottom(to: bottomAnchor, constant: sectionHeaderToTopOfDevice() + spacing.xxs + spacing.xxs),
            .leading(to: leadingAnchor, constant: spacing.ml),
            .trailing(to: trailingAnchor, constant: spacing.ml)
        ])
    }
    
    // MARK: - Button Action
    @IBAction func closeTapped() {
        closeHandler?()
        removeFromSuperview()
    }
    
    // MARK: - Config Data
    func configuire(model: FrequencyUIModel) {
        self.titleLabel.text = "\(model.title) (\(model.totalItems) \(strings.times))"
        for item in model.charCounts {
            let vStack = UIStackView()
            vStack.do {
                $0.axis = .vertical
                $0.spacing = spacing.md
                $0.alignment = .center
                $0.distribution = .fill
            }
            
            let circleView = UIView()
            circleView.do {
                $0.backgroundColor = .white
                $0.clipsToBounds = true
                $0.layer.cornerRadius = spacing.l
            }
            
            let charLabel = UILabel()
            charLabel.do {
                $0.text = item.char
                $0.textColor = colors.primaryColor
                $0.textAlignment = .center
                $0.font = .systemFont(ofSize: fontSize.title, weight: .regular)
            }
            
            circleView.addSubview(charLabel)
            circleView.constrain([
                .height(constant: spacing.xxl),
                .width(constant: spacing.xxl)
            ])
            charLabel.constrain([
                .centerX(to: circleView.centerXAnchor),
                .centerY(to: circleView.centerYAnchor)
            ])
            
            let label = UILabel()
            label.textColor = .white
            label.text = "\(item.count) \(strings.times)"
            
            vStack.addArrangedSubview(circleView)
            vStack.addArrangedSubview(label)
            
            innerStackView.addArrangedSubview(vStack)
        }
    }
}
