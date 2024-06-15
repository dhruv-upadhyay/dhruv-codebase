//
//  ContactListView.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit

class ContactListView: UIView {
    private let mainView = UIView()
    private let stackView = UIStackView()
    private let title = Label(type: .contactTitle)
    private let desc = Label(type: .contactDesc)
    private let image = UIImageView()
    private let divider = UIView()
    
    struct Design {
        static let zero: CGFloat = 0
        static let one: CGFloat = 1
        static let mainViewInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        static let dividerViewInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let imageSize: CGFloat = 52
        static let radius: CGFloat = 26
        static let spacing6: CGFloat = 6
        static let margin12: CGFloat = 12
        static let margin5: CGFloat = 5
    }
    
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        stackView.do {
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = Design.spacing6
        }

        divider.backgroundColor = UIColor.BrandColour.Gray.mauve3.withAlphaComponent(0.7)
    }
    
    private func doLayout() {
        stackView.addArrangedSubviews([title, desc])
        mainView.addSubviews([image, stackView, divider])
        addSubview(mainView)
        
        mainView.pinTo(self, insets: Design.mainViewInsets)
        image.constrain([
            image.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Design.zero),
            image.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: Design.zero),
            image.heightAnchor.constraint(equalToConstant: Design.imageSize),
            image.widthAnchor.constraint(equalToConstant: Design.imageSize)
        ])
        
        stackView.constrain([
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Design.zero),
            stackView.leftAnchor.constraint(equalTo: image.rightAnchor, constant: Design.margin12),
            stackView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: Design.zero)
        ])
        
        divider.constrain([
            divider.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Design.margin12),
            divider.heightAnchor.constraint(equalToConstant: Design.one)
        ])
        
        divider.pinTo(mainView, insets: Design.dividerViewInsets, pinStyle: .bottom)
    }
    
    func setData(data: ContactListModel) {
        title.setText(data.name)
        desc.setText(data.number)
        image.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
}
