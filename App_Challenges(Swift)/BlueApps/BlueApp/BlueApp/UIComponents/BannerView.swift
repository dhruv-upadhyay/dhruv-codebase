//
//  BannerView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import UIKit

class BannerView: UIView {
    
    // MARK: - UI Components
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let shadowView = UIImageView()
    private let stackView = UIStackView()
    private let subTitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let pageControl = UIPageControl()
    
    // MARK: - Properties
    private var banners: [BannerUIModel] = []
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Constants
    private let images = Constants.Images()
    private let colors = Constants.Colors()
    private let fontSize = Constants.FontSize()
    private let spacing = Constants.Spacing()
    
    // MARK: - Callbacks
    var onCurrentIndexUpdate: ((Int) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTheme()
        doLayout()
    }
    
    // MARK: - Setup
    private func setTheme() {
        shadowView.image = images.icShadow
        collectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = .zero
            $0.setCollectionViewLayout(layout, animated: false)
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = colors.primaryColor
            $0.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
        
        titleLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: fontSize.largeTitle, weight: .bold)
        }
        
        subTitleLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: fontSize.body, weight: .regular)
        }
        stackView.do {
            $0.axis = .vertical
            $0.spacing = spacing.xxs
            $0.alignment = .center
            $0.distribution = .fill
        }
    }
    
    /// View layout
    private func doLayout() {
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(titleLabel)
        
        addSubviews(collectionView, shadowView, pageControl, stackView)
        collectionView.pinTo(self, insets: UIEdgeInsets(top: .zero, left: .zero, bottom: spacing.xl, right: .zero), safeArea: false)
        shadowView.pinTo(self, safeArea: false)
        pageControl.constrain([
            .bottom(to: bottomAnchor, constant: spacing.sm),
            .centerX(to: centerXAnchor)
        ])
        
        stackView.constrain([
            .bottom(to: pageControl.topAnchor, constant: spacing.md),
            .centerX(to: centerXAnchor)
        ])
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: spacing.ultraMega)
        collectionViewHeightConstraint?.isActive = true
    }
    
    // MARK: - Config data
    func configure(with banners: [BannerUIModel], currentIndex: Int = .zero) {
        self.banners = banners
        
        pageControl.do {
            $0.numberOfPages = banners.count
            $0.currentPage = currentIndex
            $0.currentPageIndicatorTintColor = .white
            $0.pageIndicatorTintColor = colors.indicatorColor
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: .zero), at: .centeredHorizontally, animated: false)
            self.updateBannerHeight(forIndex: currentIndex)
        }
    }
    
    // MARK: - Update constraints
    private func updateBannerHeight(forIndex index: Int) {
        guard index >= .zero, index < banners.count else { return }
        
        let imageName = banners[index].image
        titleLabel.text = banners[index].title
        subTitleLabel.text = banners[index].subtitle
        
        if let image = UIImage(named: imageName) {
            let newHeight = image.size.height + spacing.xxxl
            self.collectionViewHeightConstraint?.constant = newHeight
        }
        onCurrentIndexUpdate?(index)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension BannerView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: banners[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = self.collectionViewHeightConstraint?.constant ?? spacing.ultraMega
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
        updateBannerHeight(forIndex: page)
    }
}
