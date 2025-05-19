//
//  UIView+Extension.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import UIKit

extension UIView {

    /// Edge types with target view and optional constant
    enum FlexibleEdge {
        case top(to: NSLayoutYAxisAnchor, constant: CGFloat = 0)
        case bottom(to: NSLayoutYAxisAnchor, constant: CGFloat = 0)
        case leading(to: NSLayoutXAxisAnchor, constant: CGFloat = 0)
        case trailing(to: NSLayoutXAxisAnchor, constant: CGFloat = 0)
        case centerX(to: NSLayoutXAxisAnchor, constant: CGFloat = 0)
        case centerY(to: NSLayoutYAxisAnchor, constant: CGFloat = 0)
        case height(constant: CGFloat)
        case width(constant: CGFloat)
    }

    /// Add multiple views at once
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    /// Apply constraints with flexible targets per edge
    @discardableResult
    func constrain(
        _ edges: [FlexibleEdge],
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []

        for edge in edges {
            switch edge {
            case .top(let anchor, let constant):
                constraints.append(topAnchor.constraint(equalTo: anchor, constant: constant))
            case .bottom(let anchor, let constant):
                constraints.append(bottomAnchor.constraint(equalTo: anchor, constant: -constant))
            case .leading(let anchor, let constant):
                constraints.append(leadingAnchor.constraint(equalTo: anchor, constant: constant))
            case .trailing(let anchor, let constant):
                constraints.append(trailingAnchor.constraint(equalTo: anchor, constant: -constant))
            case .centerX(to: let anchor, constant: let constant):
                constraints.append(centerXAnchor.constraint(equalTo: anchor, constant: constant))
            case .centerY(to: let anchor, constant: let constant):
                constraints.append(centerYAnchor.constraint(equalTo: anchor, constant: constant))
            case .height(constant: let constant):
                constraints.append(heightAnchor.constraint(equalToConstant: constant))
            case .width(constant: let constant):
                constraints.append(widthAnchor.constraint(equalToConstant: constant))
            }
        }

        if activate {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
    
    /// Pin all edges to another view, with safe area and insets control
    func pinTo(
        _ targetView: UIView,
        insets: UIEdgeInsets = .zero,
        safeArea: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchorTarget = safeArea ?  targetView.safeAreaLayoutGuide.topAnchor : targetView.topAnchor
        let bottomAnchorTarget = safeArea ? targetView.safeAreaLayoutGuide.bottomAnchor : targetView.bottomAnchor
        let leadingAnchorTarget = safeArea ? targetView.safeAreaLayoutGuide.leadingAnchor : targetView.leadingAnchor
        let trailingAnchorTarget = safeArea ? targetView.safeAreaLayoutGuide.trailingAnchor : targetView.trailingAnchor
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchorTarget, constant: insets.top),
            bottomAnchor.constraint(equalTo: bottomAnchorTarget, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: leadingAnchorTarget, constant: insets.left),
            trailingAnchor.constraint(equalTo: trailingAnchorTarget, constant: -insets.right)
        ])
    }
    
    /// Apply gradient to view
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil,
                       startPoint: CGPoint = CGPoint(x: 0, y: 0),
                       endPoint: CGPoint = CGPoint(x: 0, y: 1),
                       cornerRadius: CGFloat = 0) {
        
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius

        layer.insertSublayer(gradient, at: 0)
    }
}


