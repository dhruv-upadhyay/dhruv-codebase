//
//  LandingPageVC.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import UIKit

class LandingPageVC: BaseVC {
    private let titleView = UIView()
    private let titleLabel = Label(type: .head)
    private let tableView = UITableView()
    let viewModel = LandingPageViewModel()
    private let button = ButtonView()
    
    struct Design {
        static let zero: CGFloat = 0
        static let lableInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let titleViewInsets: UIEdgeInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        static let white: UIColor = UIColor.BrandColour.Custom.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        doLayout()
    }
    
    private func setTheme() {
        titleLabel.setText(viewModel.getTitle())
        tableView.do {
            $0.register(cell: GenericTableCell<LandingPageView>.self)
            $0.register(cell: GenericTableCell<ButtonView>.self)
            $0.separatorStyle = .none
            $0.backgroundColor = Design.white
            $0.layer.position = .zero
            $0.dataSource = self
        }
    }
    
    private func doLayout() {
        titleView.addSubview(titleLabel)
        view.addSubviews([titleView, tableView])
        titleLabel.pinTo(titleView, insets: Design.lableInsets)
        titleView.pinTo(view, insets: Design.titleViewInsets, pinStyle: .top)
        tableView.constrain([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Design.zero),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Design.zero),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Design.zero),
            tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: Design.zero)
        ])
    }
}

extension LandingPageVC: ButtonDelegate {
    func onClickButton() {
        tableView.reloadData()
    }
}

extension LandingPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTotalRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.getRowType(index: indexPath.row) {
        case .currencyView:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<LandingPageView>
            cell.view.delegate = self
            cell.view.setData(data: viewModel.getScreenData())
            return cell
        case .convertButton:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<ButtonView>
            cell.view.delegate = self
            cell.view.setData(data: viewModel.getButton())
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension LandingPageVC: LandingPageDelegate {
    func onClickDone() {
        tableView.reloadData()
    }
    
    func onClickSwipe() {
        viewModel.swipeData()
        tableView.reloadData()
    }
    
    func startEditing() {
        /// No code
    }
    
    func changeValue(text: String) {
        viewModel.setFromValue(value: text)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func onClickDropdown(tag: Int) {
        viewModel.setViewType(tag: tag)
        let vc = CurrencyPopupVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.viewModel.setData(data: viewModel.getAllData())
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
}

extension LandingPageVC: CurrencyPopupDelegate {
    func onClickOption(tag: Int) {
        viewModel.setSelectedCurrency(row: tag, type: viewModel.getViewType())
        tableView.reloadData()
    }
}
