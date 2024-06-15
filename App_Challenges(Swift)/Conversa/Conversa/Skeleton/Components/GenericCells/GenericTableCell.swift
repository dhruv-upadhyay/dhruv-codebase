//
//  ViewDocumnetDetailsViewController.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

enum GenericCellSelectionStyle {
    case none
    case bounce
    case highlight
}

protocol Recyclable {
    func prepareForReuse()
}

final class GenericTableSupplementaryView<ContentView>: UITableViewHeaderFooterView where ContentView: UIView {
    let view = ContentView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        
        view.pinTo(self)
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

final class GenericTableCell<ContentView>: UITableViewCell where ContentView: UIView {
    let view = ContentView()
    var contentSelectionStyle: GenericCellSelectionStyle = .none
    
    private let selectionView = { () -> SelectionOverlayView in
        let view = SelectionOverlayView()
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let view = view as? Recyclable {
            view.prepareForReuse()
        }
    }
    
    private func doLayout() {
		
        contentView.addSubviews([view, selectionView])
        selectionStyle = .none
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero
                
        view.pinTo(contentView)
        selectionView.pinTo(contentView)
        
    }
    
    var contentMargins: UIEdgeInsets {
        get {
            return contentView.layoutMargins
        }
        
        set (newValue) {
            contentView.layoutMargins = newValue
        }
    }
    
    func removeSeparatorInsets() {
        separatorInset = .zero
    }
    
    func removeSeparator() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: UIScreen.main.bounds.width * 2.0)
    }
    
    private func animateBounce(forward: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: forward ? 0.95 : 1.0, y: forward ? 0.95 : 1.0)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contentSelectionStyle == .bounce {
            animateBounce(forward: true)
        }
        else if self.contentSelectionStyle == .highlight {
            selectionView.isHidden = false
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentSelectionStyle == .bounce {
            animateBounce(forward: false)
        }
        else if contentSelectionStyle == .highlight {
            selectionView.isHidden = true
        }
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contentSelectionStyle == .bounce {
            animateBounce(forward: false)
        }
        else if contentSelectionStyle == .highlight {
            selectionView.isHidden = true
        }
        
        super.touchesCancelled(touches, with: event)
    }
}

