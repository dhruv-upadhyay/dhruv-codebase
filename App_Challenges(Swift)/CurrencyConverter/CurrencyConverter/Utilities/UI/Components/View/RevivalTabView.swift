//
//  RevivalTabView.swift
//  Revival
//
//  Created by Torinit Technologies on 06/04/22.
//

import UIKit

class RevivalTabView: UIView {
    
    private let contentView = UIView()
    private let itemHeight: CGFloat = 44.0
    private let tabBarCnt = UITabBarController()
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        contentView.do {
            $0.layer.cornerRadius = 5.0
            $0.layer.masksToBounds = true
            $0.backgroundColor = .white
        }
        
        tabBarCnt.do {
            $0.tabBar.tintColor = .black
        }
    }
    
    private func doLayout() {
        addSubview(contentView)
        contentView.addSubview(tabBarCnt.view)
        
        contentView.constrain([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
        
        tabBarCnt.view.constrain([
            tabBarCnt.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tabBarCnt.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            tabBarCnt.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tabBarCnt.view.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
