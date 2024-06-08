//
//  View.swift
//  Pace365
//
//  Created by Dhruv Upadhyay on 02/11/22.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    public func priority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}

public protocol Constrainable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: Constrainable {}
extension UILayoutGuide: Constrainable {}

// MARK: Consraints, Subviews, Gesture
extension UIView {
    
    @discardableResult
    func setupViewTap(gesture: UITapGestureRecognizer, tapsRequired: Int = 1, touchesRequired: Int = 1) -> UITapGestureRecognizer {
        isUserInteractionEnabled = true
        gesture.numberOfTapsRequired = tapsRequired
        gesture.numberOfTouchesRequired = touchesRequired
        addGestureRecognizer(gesture)
        return gesture
    }
    
    @discardableResult
    func constrain(_ constraints: [NSLayoutConstraint]) -> Self {
        NSLayoutConstraint.activate(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func addSubviews(_ listofViews: [UIView]) -> Self {
        for view in listofViews {
            self.addSubview(view)
        }
        return self
    }
    
    public func subviews(where: (_ view: UIView) -> Bool) -> [UIView] {
        return self.subviews.flatMap { subview -> [UIView] in
            var result = subview.subviews(where: `where`)
            if `where`(subview) {
                result.append(subview)
            }
            return result
        }
    }
    
    private class func getAllSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }
    
    public func getAllSubviews<T: UIView>() -> [T] {
        return self.subviews.flatMap { subview -> [T] in
            var result = subview.getAllSubviews() as [T]
            if let view = subview as? T {
                result.append(view)
            }
            return result
        }
    }
    
    public func setGradientBackground() {
        let colorTop = UIColor.BrandColour.Custom.white
        
        //UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.BrandColour.Custom.viewBackgroundColor
        
//        UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
}

// MARK: Auto Layout
 extension UIView {
    
    @discardableResult
    func pinTo(insets: UIEdgeInsets = .zero, safeArea: Bool = false) -> Self {
        if let superview = self.superview {
            return self.pinTo(superview, insets: insets, safeArea: safeArea)
        }
        
        fatalError("View: \(self) is not part of the View Hierarchy!")
    }
    
    @discardableResult
    func pinTo(_ view: UIView, insets: UIEdgeInsets = .zero, safeArea: Bool = false) -> Self {
        if safeArea {
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
            ])
        }
        else {
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
            ])
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func pinTo(_ margins: UILayoutGuide, insets: UIEdgeInsets = .zero) -> Self {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -insets.bottom)
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func pinTo(_ view: UIView, insets: UIEdgeInsets = .zero, safeArea: Bool = false, pinStyle: UIViewPinStyle) -> Self {
       
        let topAnchor = (safeArea) ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let leftAnchor = (safeArea) ? view.safeAreaLayoutGuide.leftAnchor : view.leftAnchor
        let rightAnchor = (safeArea) ? view.safeAreaLayoutGuide.rightAnchor : view.rightAnchor
        let bottomAnchor = (safeArea) ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        let centerXAnchor = (safeArea) ? view.safeAreaLayoutGuide.centerXAnchor : view.centerXAnchor
        let centerYAnchor = (safeArea) ? view.safeAreaLayoutGuide.centerYAnchor : view.centerYAnchor
        
        switch pinStyle {
        case .top:
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
            ])
        case .left:
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                self.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
        case .right:
            NSLayoutConstraint.activate([
                self.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ])
        case .center:
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: centerXAnchor),
                self.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
 
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func pinTo(_ margins: UILayoutGuide, insets: UIEdgeInsets = .zero, pinStyle: UIViewPinStyle) -> Self {
        
        switch pinStyle {
        case .top:
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: insets.left),
                self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top)
            ])
        case .left:
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: insets.left),
                self.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -insets.bottom)
            ])
        case .right:
            NSLayoutConstraint.activate([
                self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -insets.bottom)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: insets.left),
                self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -insets.right),
                self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -insets.bottom)
            ])
        case .center:
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                self.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
            ])
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
  /// SafeAnchors
    var safeTopAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.topAnchor
    }

    var safeLeftAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.leftAnchor
    }

    var safeRightAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.rightAnchor
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.bottomAnchor
    }
    
    
    func getSafeHeight(type: SafePosition, height: CGFloat = 0) -> CGFloat {
        guard let window = UIWindow.getKeyWindow() else {
            return height
        }

        if type == .bottom {
            return window.safeAreaInsets.bottom + height
        }

        return window.safeAreaInsets.top + height
    }
    
    func getStatusBarHeight(height: CGFloat = 0) -> CGFloat {
        guard let window = UIWindow.getKeyWindow() else {
            return height
        }
        
        let statusbarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusbarHeight + height
    }
    
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}

// MARK: Accessibility
extension UIView {

    /// Accessibility options For Elements with subelements like Cells:
    /// 1. cell.applyAccessibility(text: nil, accessibility: false) + separately enabled with types/features for each element in the cell - more flexible for complicated elements
    /// 2. leave the cell default (accessible=true) and all the elements default (not accessible) -> good for regular labels as system will still read the content of the whole cell
    
    /// Accessibility Voice Over
    func applyAccessibility<T: NSObject>(control: T? = nil, text: String?, hint: String? = nil, type: UIAccessibilityTraits? = nil, value: String? = nil, accessibility: Bool? = true) {
        var item: NSObject = self
        
        if let control = control {
            item = control
        }
        
        if let text = text {
            item.accessibilityLabel = text
        }
        
        if let hint = hint {
            item.accessibilityHint = hint
        }
        
        if let type = type {
            item.accessibilityTraits = type
        }
        
        if let value = value {
            item.accessibilityValue = value
        }
        
        if let accessibility = accessibility {
            item.isAccessibilityElement = accessibility
        }
    }
    
    func getAccessibleMultiplier(onlyLarge: Bool = false) -> CGFloat {
        var value: CGFloat = 1
        if traitCollection.preferredContentSizeCategory > .accessibilityExtraExtraLarge {
            value *= 1.8
        } else if traitCollection.preferredContentSizeCategory > .accessibilityExtraLarge {
            value *= 1.6
        } else if traitCollection.preferredContentSizeCategory > .extraExtraExtraLarge {
            value *= 1.4
        }  else if traitCollection.preferredContentSizeCategory > .extraLarge {
            value *= 1.2
        } else if traitCollection.preferredContentSizeCategory < .large {
            value = onlyLarge ? 1 : 0.8
        }
        
        return value
    }
    
    func getHeightAccessibleMultiplier() -> CGFloat {
        return getAccessibleMultiplier() * 1.1
    }
    
    func getAccessibleScale(defaultScale: UIImage.SymbolScale = .small) -> UIImage.SymbolScale {
        var scale = defaultScale
        if traitCollection.preferredContentSizeCategory > .accessibilityLarge {
            scale = .large
        } else if traitCollection.preferredContentSizeCategory > .extraExtraLarge {
            if defaultScale == .small {
                scale = .medium
            } else if defaultScale == .large {
                scale = .large
            }
        }
        
        return scale
    }
    
    /// Accessibility Element Size
    func isIncreasedAreaHit(_ point: CGPoint, insetArea: UIEdgeInsets? = nil, insetPoint: CGPoint? = nil) -> Bool {
        guard isUserInteractionEnabled, !isHidden, alpha >= 0.01 else { return false }

        if let insetPoint = insetPoint {
            return frame.insetBy(dx: insetPoint.x, dy: insetPoint.y).contains(point)
        } else if let insetArea = insetArea {
            return bounds.inset(by: insetArea).contains(point)
        }
        
        return false
    }
}

// UI
extension UIView {
    func addShadow(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 20.0, shadowOpacity: Float = 0.08, shadowColor: UIColor = .white, offset: CGSize = CGSize(width: 0, height: 4)) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = frame.width
        var viewHeight = frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if !top {
            y += (shadowRadius + 1)
        }
        if !bottom {
            viewHeight -= (shadowRadius + 1)
        }
        if !left {
            x += (shadowRadius + 1)
        }
        if !right {
            viewWidth -= (shadowRadius + 1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        layer.shadowPath = path.cgPath
    }

    func addHorizontalGradient(colorFrom: UIColor, colorTo: UIColor) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.colors = [colorTo.cgColor, colorFrom.withAlphaComponent(0).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    /*
     // Usage:
     view.addBorder(edges: [.all]) // All with default arguments
     view.addBorder(edges: [.top], color: .green) // Just Top, green, default thickness
     view.addBorder(edges: [.left, .right, .bottom], color: .red, borderWidth: 3) // All except Top, red, thickness 3
     */
    @discardableResult
    func addBorders(edges: UIRectEdge, color: UIColor, inset: CGFloat = 0.0, borderWidth: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(
                formats.flatMap {
                    NSLayoutConstraint.constraints(
                        withVisualFormat: $0,
                        options: [],
                        metrics: ["inset": inset, "thickness": borderWidth],
                        views: ["border": border]
                    )
                }
            )
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

extension UIView {
    @discardableResult
    func pin(_ constraints: [NSLayoutConstraint]) -> Self {
        NSLayoutConstraint.activate(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func pin(to constrainable: Constrainable, insets: UIEdgeInsets = .zero) -> Self {
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: constrainable.leftAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: constrainable.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: constrainable.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: -insets.bottom)
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    // MARK: -
    
    @discardableResult
    func pin(_ anchors: [ConstraintAnchor] = [.pinned(.zero)]) -> Self {
        if let superview = self.superview {
            return self.pin(to: superview, anchors)
        }
        
        fatalError("\(self) is not part of the view hierarchy")
    }
    
    @discardableResult
    func pin(to constrainable: Constrainable, _ anchors: [ConstraintAnchor]) -> Self {
        anchors.compactMap({
            resolve($0, constrainable)
        }).forEach({
            $0.isActive = true
        })
        
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}


public struct ConstraintAnchor {
    internal let anchor: ConstraintAnchorType
    
    /// Pins left to left
    public static let left = ConstraintAnchor(anchor: .left(0.0, .required))
    
    /// Pins right to left
    public static let leftRight = ConstraintAnchor(anchor: .leftRight(0.0, .required))
    
    /// Pins right to right
    public static let right = ConstraintAnchor(anchor: .right(0.0, .required))
    
    /// Pins right to Left
    public static let rightLeft = ConstraintAnchor(anchor: .rightLeft(0.0, .required))
    
    /// Pins top to top
    public static let top = ConstraintAnchor(anchor: .top(0.0, .required))
    
    /// Pins top to bottom
    public static let topBottom = ConstraintAnchor(anchor: .topBottom(0.0, .required))
    
    /// Pins bottom to bottom
    public static let bottom = ConstraintAnchor(anchor: .bottom(0.0, .required))
    
    /// Pins bottom to top
    public static let bottomTop = ConstraintAnchor(anchor: .bottomTop(0.0, .required))
    
    /// Pins width to width
    public static let width = ConstraintAnchor(anchor: .width(-1.0, .required))
    
    /// Pins width to height
    public static let widthHeight = ConstraintAnchor(anchor: .widthHeight(.required))
    
    /// Pins height to height
    public static let height = ConstraintAnchor(anchor: .height(-1.0, .required))
    
    /// Pins height to width
    public static let heightWidth = ConstraintAnchor(anchor: .heightWidth(.required))
    
    /// Pins centerX to centerX
    public static let centerX = ConstraintAnchor(anchor: .centerX(0.0, .required))
    
    /// Pins centerY to centerY
    public static let centerY = ConstraintAnchor(anchor: .centerY(0.0, .required))
    
    /// Pins all around
    public static let pinned = ConstraintAnchor(anchor: .pinned(.zero))
}

extension ConstraintAnchor {
    /// Pins left to left
    public static func left(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .left(offset, priority))
    }
    
    /// Pins left to left
    public static func left(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .leftOf(constrainable, offset, priority))
    }
    
    /// Pins left to right
    public static func leftRight(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .leftRight(offset, priority))
    }
    
    /// Pins left to right
    public static func leftRight(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .leftRightOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins right to right
    public static func right(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .right(offset, priority))
    }
    
    /// Pins right to right
    public static func right(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .rightOf(constrainable, offset, priority))
    }
    
    /// Pins right to left
    public static func rightLeft(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .rightLeft(offset, priority))
    }
    
    /// Pins right to left
    public static func rightLeft(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .rightLeftOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins top to top
    public static func top(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .top(offset, priority))
    }
    
    /// Pins top to top
    public static func top(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .topOf(constrainable, offset, priority))
    }
    
    /// Pins top to bottom
    public static func topBottom(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .topBottom(offset, priority))
    }
    
    /// Pins top to bottom
    public static func topBottom(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .topBottomOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins bottom to bottom
    public static func bottom(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .bottom(offset, priority))
    }
    
    /// Pins bottom to bottom
    public static func bottom(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .bottomOf(constrainable, offset, priority))
    }
    
    /// Pins bottom to top
    public static func bottomTop(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .bottomTop(offset, priority))
    }
    
    /// Pins bottom to top
    public static func bottomTop(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .bottomTopOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins width to width
    public static func width(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .width(offset, priority))
    }
    
    /// Pins width to width
    public static func widthOf(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .widthOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins height to height
    public static func height(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .height(offset, priority))
    }
    
    /// Pins height to height
    public static func heightOf(_ constrainable: Constrainable, _ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .heightOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins centerX to centerX
    public static func centerX(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .centerX(offset, priority))
    }
    
    /// Pins centerX to centerX
    public static func centerX(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .centerXOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins centerY to centerY
    public static func centerY(_ offset: CGFloat, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .centerY(offset, priority))
    }
    
    /// Pins centerY to centerY
    public static func centerYOf(_ constrainable: Constrainable, _ offset: CGFloat = 0.0, _ priority: UILayoutPriority = .required) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .centerYOf(constrainable, offset, priority))
    }
}

extension ConstraintAnchor {
    /// Pins all around
    public static func pinned(_ insets: UIEdgeInsets) -> ConstraintAnchor {
        return ConstraintAnchor(anchor: .pinned(insets))
    }
    
    /// Pins greater than some other constraint
    public static func greaterThan(_ anchor: ConstraintAnchor) -> ConstraintAnchor {
        if case .greaterThan = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        if case .lessThan = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        if case .pinned = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        return ConstraintAnchor(anchor: .greaterThan(anchor.anchor))
    }
    
    /// Pins less than some other constraint
    public static func lessThan(_ anchor: ConstraintAnchor) -> ConstraintAnchor {
        if case .greaterThan = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        if case .lessThan = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        if case .pinned = anchor.anchor {
            fatalError("Invalid Constraint")
        }
        
        return ConstraintAnchor(anchor: .lessThan(anchor.anchor))
    }
}


// MARK: - Internal
private extension UIView { // swiftlint:disable:this no_extension_access_modifier
    private func resolve(_ anchor: ConstraintAnchor, _ constrainable: Constrainable) -> NSLayoutConstraint? { // swiftlint:disable:this cyclomatic_complexity
        switch anchor.anchor {
        // MARK: -
        case .left(let offset, let priority):
            return self.leftAnchor.constraint(equalTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRight(let offset, let priority):
            return self.rightAnchor.constraint(equalTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(equalTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(equalTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .right(let offset, let priority):
            return self.rightAnchor.constraint(equalTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeft(let offset, let priority):
            return self.leftAnchor.constraint(equalTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(equalTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(equalTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .top(let offset, let priority):
            return self.topAnchor.constraint(equalTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottom(let offset, let priority):
            return self.bottomAnchor.constraint(equalTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(equalTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(equalTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .bottom(let offset, let priority):
            return self.bottomAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTop(let offset, let priority):
            return self.topAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTopOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .width(let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(equalTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(equalToConstant: width).priority(priority)
            
        case .widthHeight(let priority):
            return self.widthAnchor.constraint(equalTo: constrainable.heightAnchor).priority(priority)
            
        case .widthOf(let constrainable, let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(equalTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(equalToConstant: width).priority(priority)
            
        // MARK: -
        case .height(let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(equalTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(equalToConstant: height).priority(priority)
            
        case .heightWidth(let priority):
            return self.heightAnchor.constraint(equalTo: constrainable.widthAnchor).priority(priority)
            
        case .heightOf(let constrainable, let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(equalTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(equalToConstant: height).priority(priority)
            
        // MARK: -
        case .centerX(let offset, let priority):
            return self.centerXAnchor.constraint(equalTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerXOf(let constrainable, let offset, let priority):
            return self.centerXAnchor.constraint(equalTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerY(let offset, let priority):
            return self.centerYAnchor.constraint(equalTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        case .centerYOf(let constrainable, let offset, let priority):
            return self.centerYAnchor.constraint(equalTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .pinned(let insets):
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: constrainable.leftAnchor, constant: insets.left),
                self.rightAnchor.constraint(equalTo: constrainable.rightAnchor, constant: -insets.right),
                self.topAnchor.constraint(equalTo: constrainable.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: constrainable.bottomAnchor, constant: -insets.bottom)
            ])
            return nil
            
        case .greaterThan(let type):
            return resolveGreater(type, constrainable)
            
        case .lessThan(let type):
            return resolveLess(type, constrainable)
        }
    }
    
    private func resolveGreater(_ anchor: ConstraintAnchorType, _ constrainable: Constrainable) -> NSLayoutConstraint? { // swiftlint:disable:this cyclomatic_complexity
        switch anchor {
        // MARK: -
        case .left(let offset, let priority):
            return self.leftAnchor.constraint(greaterThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRight(let offset, let priority):
            return self.rightAnchor.constraint(greaterThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(greaterThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(greaterThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .right(let offset, let priority):
            return self.rightAnchor.constraint(greaterThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeft(let offset, let priority):
            return self.leftAnchor.constraint(greaterThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(greaterThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(greaterThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .top(let offset, let priority):
            return self.topAnchor.constraint(greaterThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottom(let offset, let priority):
            return self.bottomAnchor.constraint(greaterThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(greaterThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(greaterThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .bottom(let offset, let priority):
            return self.bottomAnchor.constraint(greaterThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTop(let offset, let priority):
            return self.topAnchor.constraint(greaterThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(greaterThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTopOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(greaterThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .width(let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(greaterThanOrEqualTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(greaterThanOrEqualToConstant: width).priority(priority)
            
        case .widthHeight(let priority):
            return self.widthAnchor.constraint(greaterThanOrEqualTo: constrainable.heightAnchor).priority(priority)
            
        case .widthOf(let constrainable, let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(greaterThanOrEqualTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(greaterThanOrEqualToConstant: width).priority(priority)
            
        // MARK: -
        case .height(let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(greaterThanOrEqualTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).priority(priority)
            
        case .heightWidth(let priority):
            return self.heightAnchor.constraint(greaterThanOrEqualTo: constrainable.widthAnchor).priority(priority)
            
        case .heightOf(let constrainable, let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(greaterThanOrEqualTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).priority(priority)
            
        // MARK: -
        case .centerX(let offset, let priority):
            return self.centerXAnchor.constraint(greaterThanOrEqualTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerXOf(let constrainable, let offset, let priority):
            return self.centerXAnchor.constraint(greaterThanOrEqualTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerY(let offset, let priority):
            return self.centerYAnchor.constraint(greaterThanOrEqualTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        case .centerYOf(let constrainable, let offset, let priority):
            return self.centerYAnchor.constraint(greaterThanOrEqualTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        // MARK: -
        default:
            fatalError("Invalid Greater Than Constraint")
        }
    }
    
    private func resolveLess(_ anchor: ConstraintAnchorType, _ constrainable: Constrainable) -> NSLayoutConstraint? { // swiftlint:disable:this cyclomatic_complexity
        switch anchor {
        // MARK: -
        case .left(let offset, let priority):
            return self.leftAnchor.constraint(lessThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRight(let offset, let priority):
            return self.rightAnchor.constraint(lessThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(lessThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        case .leftRightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(lessThanOrEqualTo: constrainable.leftAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .right(let offset, let priority):
            return self.rightAnchor.constraint(lessThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeft(let offset, let priority):
            return self.leftAnchor.constraint(lessThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightOf(let constrainable, let offset, let priority):
            return self.rightAnchor.constraint(lessThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        case .rightLeftOf(let constrainable, let offset, let priority):
            return self.leftAnchor.constraint(lessThanOrEqualTo: constrainable.rightAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .top(let offset, let priority):
            return self.topAnchor.constraint(lessThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottom(let offset, let priority):
            return self.bottomAnchor.constraint(lessThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(lessThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        case .topBottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(lessThanOrEqualTo: constrainable.topAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .bottom(let offset, let priority):
            return self.bottomAnchor.constraint(lessThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTop(let offset, let priority):
            return self.topAnchor.constraint(lessThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomOf(let constrainable, let offset, let priority):
            return self.bottomAnchor.constraint(lessThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        case .bottomTopOf(let constrainable, let offset, let priority):
            return self.topAnchor.constraint(lessThanOrEqualTo: constrainable.bottomAnchor, constant: offset).priority(priority)
            
        // MARK: -
        case .width(let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(lessThanOrEqualTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(lessThanOrEqualToConstant: width).priority(priority)
            
        case .widthHeight(let priority):
            return self.widthAnchor.constraint(lessThanOrEqualTo: constrainable.heightAnchor).priority(priority)
            
        case .widthOf(let constrainable, let width, let priority):
            return width < 0.0 ? self.widthAnchor.constraint(lessThanOrEqualTo: constrainable.widthAnchor).priority(priority) : self.widthAnchor.constraint(lessThanOrEqualToConstant: width).priority(priority)
            
        // MARK: -
        case .height(let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(lessThanOrEqualTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(lessThanOrEqualToConstant: height).priority(priority)
            
        case .heightWidth(let priority):
            return self.heightAnchor.constraint(lessThanOrEqualTo: constrainable.widthAnchor).priority(priority)
            
        case .heightOf(let constrainable, let height, let priority):
            return height < 0.0 ? self.heightAnchor.constraint(lessThanOrEqualTo: constrainable.heightAnchor).priority(priority) : self.heightAnchor.constraint(lessThanOrEqualToConstant: height).priority(priority)
            
        // MARK: -
        case .centerX(let offset, let priority):
            return self.centerXAnchor.constraint(lessThanOrEqualTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerXOf(let constrainable, let offset, let priority):
            return self.centerXAnchor.constraint(lessThanOrEqualTo: constrainable.centerXAnchor, constant: offset).priority(priority)
            
        case .centerY(let offset, let priority):
            return self.centerYAnchor.constraint(lessThanOrEqualTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        case .centerYOf(let constrainable, let offset, let priority):
            return self.centerYAnchor.constraint(lessThanOrEqualTo: constrainable.centerYAnchor, constant: offset).priority(priority)
            
        // MARK: -
        default:
            fatalError("Invalid Less Than Constraint")
        }
    }
}

// MARK: - Internal
internal indirect enum ConstraintAnchorType {
    case left(CGFloat, UILayoutPriority)
    case leftRight(CGFloat, UILayoutPriority)
    case leftOf(Constrainable, CGFloat, UILayoutPriority)
    case leftRightOf(Constrainable, CGFloat, UILayoutPriority)
    
    case right(CGFloat, UILayoutPriority)
    case rightLeft(CGFloat, UILayoutPriority)
    case rightOf(Constrainable, CGFloat, UILayoutPriority)
    case rightLeftOf(Constrainable, CGFloat, UILayoutPriority)
    
    case top(CGFloat, UILayoutPriority)
    case topBottom(CGFloat, UILayoutPriority)
    case topOf(Constrainable, CGFloat, UILayoutPriority)
    case topBottomOf(Constrainable, CGFloat, UILayoutPriority)
    
    case bottom(CGFloat, UILayoutPriority)
    case bottomTop(CGFloat, UILayoutPriority)
    case bottomOf(Constrainable, CGFloat, UILayoutPriority)
    case bottomTopOf(Constrainable, CGFloat, UILayoutPriority)
    
    case width(CGFloat, UILayoutPriority)
    case widthHeight(UILayoutPriority)
    case widthOf(Constrainable, CGFloat, UILayoutPriority)
    
    case height(CGFloat, UILayoutPriority)
    case heightWidth(UILayoutPriority)
    case heightOf(Constrainable, CGFloat, UILayoutPriority)
    
    case centerX(CGFloat, UILayoutPriority)
    case centerXOf(Constrainable, CGFloat, UILayoutPriority)
    
    case centerY(CGFloat, UILayoutPriority)
    case centerYOf(Constrainable, CGFloat, UILayoutPriority)
    
    case pinned(UIEdgeInsets)
    case greaterThan(ConstraintAnchorType)
    case lessThan(ConstraintAnchorType)
} // swiftlint:disable:this file_length
