//
//  CurrencyPopupVC.swift
//  CurrencyConverter
//
// Created by Dhruv Upadhyay on 06/03/23.
//

import UIKit

protocol CurrencyPopupDelegate: NSObject {
    func onClickOption(tag: Int)
}

class CurrencyPopupVC: BaseVC {
    private let mainView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = Label(type: .currenciesTitle)
    private let searchBar = TextFieldView()
    private let tableView = UITableView()
    let viewModel = CurrencyPopupViewModel()
    weak var delegate: CurrencyPopupDelegate?
    
    struct Design {
        static let zero: CGFloat = 0
        static let margin24: CGFloat = 24
        static let size24: CGFloat = 24
        static let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        static let closeInsets: UIEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0)
        static let white: UIColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        doLayout()
    }
    
    private func setTheme() {
        titleLabel.setText(viewModel.getTitle())
        tableView.do {
            $0.register(cell: GenericTableCell<CurrencyTitleView>.self)
            $0.separatorStyle = .none
            $0.backgroundColor = Design.white
            $0.layer.position = .zero
            $0.dataSource = self
            $0.delegate = self
        }
        
        searchBar.do {
            $0.setPlaceHolder(viewModel.getPlaceholder())
            $0.delegate = self
        }
        
        closeButton.do {
            $0.setImage(UIImage(named: ImageName.icClose.rawValue), for: .normal)
            $0.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
        }
    }
    
    private func doLayout() {
        mainView.addSubviews([titleLabel, closeButton, searchBar, tableView])
        view.addSubview(mainView)
        mainView.constrain([
            mainView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: Design.zero),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Design.zero),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Design.zero),
            mainView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: Design.zero)
        ])
        
        closeButton.constrain([
            closeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Design.size24),
            closeButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: Design.size24),
            closeButton.heightAnchor.constraint(equalToConstant: Design.size24),
            closeButton.widthAnchor.constraint(equalToConstant: Design.size24),
            closeButton.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -Design.margin24)
        ])
        titleLabel.constrain([
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: Design.zero),
            titleLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -Design.margin24)
        ])
        searchBar.constrain([
            searchBar.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Design.margin24),
            searchBar.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: Design.margin24),
            searchBar.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -Design.margin24)
        ])
        tableView.constrain([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Design.margin24)
        ])
        tableView.pinTo(mainView, pinStyle: .bottom)
    }
    
    @IBAction func onClickClose(sender: UIButton) {
        dismiss(animated: true)
    }
}

extension CurrencyPopupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTotalRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<CurrencyTitleView>
        cell.view.setData(data: viewModel.getModel(row: indexPath.row))
        return cell
    }
}

extension CurrencyPopupVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onClickOption(tag: viewModel.getOptionTag(row: indexPath.row))
        dismiss(animated: true)
    }
}

extension CurrencyPopupVC: TextFieldViewDelegate {
    func formTextField(_ textField: TextFieldView, shouldChangeTextIn range: NSRange, replacementString string: String) -> Bool {
        var updatedText = textField.getTextEntered() + string
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            updatedText = String(updatedText.dropLast())
        }
        viewModel.setSearchData(value: updatedText)
        tableView.reloadData()
        return true
    }
}
