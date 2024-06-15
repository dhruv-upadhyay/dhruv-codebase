//
//  DashboardVC.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit

class DashboardVC: BaseVC {
    private let tableView = UITableView()
    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTheme()
        doLayout()
    }
    
    private func setTheme() {
        setNavigationBar(title: "Contacts", rightButton: "icAddUser")
        tableView.do {
            $0.register(cell: GenericTableCell<ContactListView>.self)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
            $0.separatorStyle = .none
        }
        
        reloadData()
    }
    
    private func reloadData() {
        viewModel.fetchUsersAndContacts { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.viewModel.isShow {
                strongSelf.tableView.do {
                    $0.reloadData()
                }
            } else {
                print("No record found!")
            }
        }
    }
    
    private func doLayout() {
        view.addSubview(tableView)
        tableView.constrain([
            tableView.topAnchor.constraint(equalTo: bottomAncher)
        ])
        tableView.pinTo(view, pinStyle: .bottom)
    }
    
    override func onClickRightButton(sender: UIButton) {
        viewModel.saveUser { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.reloadData()
        }
    }
}

extension DashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getUserCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<ContactListView>
        cell.view.setData(data: viewModel.getUser(index: indexPath.row))
        return cell
    }
}

extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
