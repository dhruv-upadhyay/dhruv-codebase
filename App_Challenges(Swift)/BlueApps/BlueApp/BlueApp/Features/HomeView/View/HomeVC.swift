//
//  HomeVC.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var heightConstraint: NSLayoutConstraint?
    private var topView = UIView()
    private let searchView = SearchBarView()
    private let circularButton = UIButton()
    
    //MARK: - Properties
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        doLayout()
    }

    private func setTheme() {
        view.backgroundColor = .white
        tableView.do {
            $0.register(cell: GenericTableCell<BannerView>.self)
            $0.register(cell: GenericTableCell<ImageDetailsView>.self)
            $0.separatorStyle = .none
            $0.backgroundColor = viewModel.colors.primaryColor
            $0.dataSource = self
            $0.delegate = self
            $0.contentInsetAdjustmentBehavior = .never
            $0.estimatedSectionHeaderHeight = .zero
            $0.estimatedSectionFooterHeight = .zero
            $0.sectionHeaderHeight = .zero
            $0.sectionFooterHeight = .zero
            $0.bounces = false
        }
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .zero
        }

        viewModel.loadData { [weak self] in
            self?.tableView.reloadData()
        }
        
        topView.do {
            $0.backgroundColor = viewModel.colors.primaryColor
            $0.isHidden = true
        }
        
        searchView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.onSearchTextChanged = { [weak self] text in
                guard let self = self else { return }
                self.viewModel.searchImages(query: text)
                self.tableView.reloadSections(IndexSet(integer: viewModel.getSectionIndex(from: .list)), with: .none)
                self.searchView.setFirstResponder()
            }
        }
        
        circularButton.do {
            $0.setImage(viewModel.images.icButton, for: .normal)
            $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }
    }

    private func doLayout() {
        view.addSubviews(tableView, topView, circularButton)
        tableView.pinTo(view, safeArea: false)
        topView.constrain([
            .top(to: view.topAnchor),
            .leading(to: view.leadingAnchor),
            .trailing(to: view.trailingAnchor)
        ])
        circularButton.constrain([
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: viewModel.spacing.ml),
            .trailing(to: view.safeAreaLayoutGuide.trailingAnchor, constant: viewModel.spacing.ml),
            .height(constant: viewModel.spacing.xxl),
            .width(constant: viewModel.spacing.xxl)
        ])
        heightConstraint = topView.heightAnchor.constraint(equalToConstant: sectionHeaderToTopOfDevice())
        heightConstraint?.isActive = true
    }
}

// MARK: - Action methods
extension HomeVC {
    @IBAction func didTapButton(_ sender: Any) {
        showFrequencyView()
    }
    
    func showFrequencyView() {
        let summaryView = FrequencySummaryView()
        tableView.isUserInteractionEnabled = false
        summaryView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.configuire(model: viewModel.getFreqViewData())
            $0.closeHandler = { [weak self] in
                guard let self = self else { return }
                self.tableView.isUserInteractionEnabled = true
            }
        }
        view.addSubview(summaryView)
        
        summaryView.constrain([
            .bottom(to: view.bottomAnchor),
            .leading(to: view.leadingAnchor),
            .trailing(to: view.trailingAnchor)
        ])
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellCount(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = viewModel.getSection(section: indexPath.section) else { return UITableViewCell() }
        
        switch type {
        case .banner:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<BannerView>
            let currentIndex = viewModel.getCurrentBannerIndex()
            cell.view.do {
                $0.configure(with: viewModel.getBanners(), currentIndex: currentIndex)
                $0.onCurrentIndexUpdate = { [weak self] index in
                    guard let self = self else { return }
                    self.viewModel.setCurrentBannerIndex(index)
                    self.viewModel.setImages(for: index)
                    self.tableView.reloadSections(IndexSet(integer: viewModel.getSectionIndex(from: .list)), with: .none)
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GenericTableCell<ImageDetailsView>
            if let value = viewModel.getImage(at: indexPath.row) {
                cell.view.configure(model: value)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let type = viewModel.getSection(section: section), type == .list else { return nil }

        let headerView = UIView()
        headerView.backgroundColor = viewModel.colors.primaryColor
        headerView.addSubview(searchView)
        
        searchView.pinTo(headerView, insets: UIEdgeInsets(top: viewModel.spacing.sm, left: viewModel.spacing.sm, bottom: viewModel.spacing.ml, right: viewModel.spacing.lg))

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let type = viewModel.getSection(section: section) else { return .leastNonzeroMagnitude }
        return type == .list ? viewModel.spacing.extraHuge : .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let indexPaths = tableView.indexPathsForVisibleRows, !indexPaths.isEmpty else { return }
        let visibleRect = CGRect(origin: tableView.contentOffset, size: tableView.bounds.size)
        let topIndexPath = indexPaths.min()
        guard let topSection = topIndexPath?.section else { return }
        let sectionRect = tableView.rect(forSection: viewModel.getSectionIndex(from: .banner))
        let visiblePart = sectionRect.intersection(visibleRect)
        
        if let type = viewModel.getSection(section: topSection) {
            if type == .banner {
                if visiblePart.height < viewModel.spacing.ultra {
                    tableView.contentInsetAdjustmentBehavior = .automatic
                    topView.isHidden = false
                } else if visiblePart.height > viewModel.spacing.ultra {
                    tableView.contentInsetAdjustmentBehavior = .never
                    topView.isHidden = true
                }
            } else {
                tableView.contentInsetAdjustmentBehavior = .automatic
                topView.isHidden = false
            }
        }
    }
}
