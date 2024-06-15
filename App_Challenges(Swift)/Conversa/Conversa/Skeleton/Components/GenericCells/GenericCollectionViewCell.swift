//
//  ViewDocumnetDetailsViewController.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

final class GenericCollectionSupplementaryView<ContentView>: UICollectionReusableView where ContentView: UIView {
    let view = ContentView()
    
    init() {
        super.init(frame: .zero)
        self.doLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let view = self.view as? Recyclable {
            view.prepareForReuse()
        }
    }
    
    private func doLayout() {
        self.addSubview(self.view)
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
        
        view.pinTo(self, safeArea: true)
    }
    
    var contentMargins: UIEdgeInsets {
        get {
            return self.layoutMargins
        }
        
        set (newValue) {
            self.layoutMargins = newValue
        }
    }
}

final class GenericCollectionViewCell<ContentView>: UICollectionViewCell where ContentView: UIView {
    let view = ContentView()
    var contentSelectionStyle: GenericCellSelectionStyle = .none
    
    private let selectionView = { () -> SelectionOverlayView in
        let view = SelectionOverlayView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let view = self.view as? Recyclable {
            view.prepareForReuse()
        }
    }
    
    private func doLayout() {
        self.contentView.addSubview(self.view)
        self.contentView.addSubview(self.selectionView)
        self.contentView.preservesSuperviewLayoutMargins = false
        self.contentView.layoutMargins = .zero
        
        view.pinTo(self.contentView)
        selectionView.pinTo(self.contentView)

    }
    
    var contentMargins: UIEdgeInsets {
        get {
            return self.contentView.layoutMargins
        }
        
        set (newValue) {
            self.contentView.layoutMargins = newValue
        }
    }
    
    private func animateBounce(forward: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: forward ? 0.95 : 1.0, y: forward ? 0.95 : 1.0)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contentSelectionStyle == .bounce {
            self.animateBounce(forward: true)
        }
        else if self.contentSelectionStyle == .highlight {
            self.selectionView.isHidden = false
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contentSelectionStyle == .bounce {
            self.animateBounce(forward: false)
        }
        else if self.contentSelectionStyle == .highlight {
            self.selectionView.isHidden = true
        }
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contentSelectionStyle == .bounce {
            self.animateBounce(forward: false)
        }
        else if self.contentSelectionStyle == .highlight {
            self.selectionView.isHidden = true
        }
        
        super.touchesCancelled(touches, with: event)
    }
}

