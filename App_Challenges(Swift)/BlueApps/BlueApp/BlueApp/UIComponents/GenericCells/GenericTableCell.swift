//
//  ViewDocumnetDetailsViewController.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
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
        contentView.addSubviews(view, selectionView)
        selectionStyle = .none
        contentView.preservesSuperviewLayoutMargins = false
        contentView.layoutMargins = .zero
                
        view.pinTo(contentView)
        selectionView.pinTo(contentView)
    }
}

