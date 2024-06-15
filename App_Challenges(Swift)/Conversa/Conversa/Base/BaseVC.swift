//
//  BaseVC.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit
import Alamofire
import SDWebImage

class BaseVC: UIViewController {
    let navDevider = UIView()
    private let navBar = UIView()
    private let leftNavButton = ActionButton()
    private let rightNavButton = ActionButton()
    private let titleView = UIView()
    private var navTitleLabel = Label(type: .navDashTitle)
    private let navDescLabel = Label(type: .navDesc)
    private let navStackView = UIStackView()
    private let stackView = UIStackView()
    private var bottomConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var rightBtnWidthConstraint: NSLayoutConstraint?
    
    struct Design {
        static let zero: CGFloat = 0
        static let buttonTitleSpace: CGFloat = 32
        static let tapArea: CGFloat = 48.0
        static let barPadding: CGFloat = 19.0
        static let imageCircleSize = CGRect(x: 8.0, y: 0, width: 40, height: 40)
        static let accessibleTapArea = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        static let navigationBarColor = UIColor.BrandColour.Navigation.white
        static let tapSize = CGSize(width: 80.0, height: 48.0)
        static let shadowOpacity: Float = 0.15
        static let shadowOffset: CGSize = CGSize(width: 2, height: 5)
        static let cornerRadius: CGFloat = 24
        static let spacing4: CGFloat = 4
        static let margin18: CGFloat = 18
        static let margin24: CGFloat = 24
        static let margin48: CGFloat = 48
        static let margin6: CGFloat = 6
        static let margin10: CGFloat = 10
        static let margin15: CGFloat = 15
        static let heightWidth48: CGFloat = 48
        static let lineNumber: Int = 1
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.BrandColour.Navigation.white
        navigationController?.navigationBar.isHidden = true
        setNavTheme()
        doNavLayout()
        hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    var prefersNavigationBarHidden: Bool {
        return false
    }
    
    var prefersBackButtonText: Bool {
        return false
    }
    
    var prefersBackButtonHidden: Bool {
        return false
    }
    
    var isConnectedToInternet: Bool {
        
        if let reachability = NetworkReachabilityManager() {
            return reachability.isReachable
        }
        return false
    }
    
    var bottomAncher: NSLayoutYAxisAnchor {
        return stackView.bottomAnchor
    }
    
    var tabbarHide: Bool = false {
        willSet {
            tabBarController?.tabBar.isHidden = newValue
        }
    }
    
    public func hideTabBar (_ hidden: Bool) {
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
    public func showDevider() {
        navBar.do {
            $0.layer.shadowOpacity = Design.shadowOpacity
            $0.layer.shadowOffset = Design.shadowOffset
            $0.layer.shadowColor = UIColor.BrandColour.Custom.gunmetal.cgColor
        }
    }
    
    private func setNavTheme() {
        leftNavButton.do {
            $0.setBackgroundColor(startColor: .clear, endColor: .clear)
            $0.addTarget(self, action: #selector(onClickLeftButton), for: .touchUpInside)
            $0.layer.cornerRadius = Design.cornerRadius
            $0.clipsToBounds = true
        }
        
        rightNavButton.do {
            $0.setBackgroundColor(startColor: .clear, endColor: .clear)
            $0.addTarget(self, action: #selector(onClickRightButton), for: .touchUpInside)
        }
        
        navStackView.do {
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = Design.spacing4
        }
        
        navBar.do {
            $0.backgroundColor = .white
        }
        
        navTitleLabel.numberOfLines = Design.lineNumber
    }
    
    func bringNavBarToFrontOf(view: UIView) {
        stackView.bringSubviewToFront(view)
    }
    
    private func doNavLayout() {
        navStackView.addArrangedSubviews([navDescLabel, navTitleLabel])
        titleView.addSubviews([navStackView])
        navBar.addSubviews([leftNavButton, titleView, rightNavButton])
        stackView.addArrangedSubviews([navBar])
        view.addSubview(stackView)
        
        stackView.constrain([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Design.zero),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Design.zero),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Design.zero)
        ])
        
        leftNavButton.constrain([
            leftNavButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: Design.margin18),
            leftNavButton.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: Design.margin24),
            leftNavButton.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -Design.margin18),
            leftNavButton.heightAnchor.constraint(equalToConstant: Design.margin48)
        ])
        widthConstraint = leftNavButton.widthAnchor.constraint(equalToConstant: Design.margin48)
        widthConstraint?.isActive = true
        
        titleView.constrain([
            titleView.leftAnchor.constraint(equalTo: leftNavButton.rightAnchor, constant: Design.margin6),
            titleView.rightAnchor.constraint(equalTo: rightNavButton.leftAnchor, constant: -Design.margin6),
            titleView.topAnchor.constraint(equalTo: navBar.topAnchor, constant: Design.zero),
            titleView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Design.zero)
        ])
        
        navStackView.constrain([
            navStackView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: Design.margin10),
            navStackView.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -Design.margin10),
            navStackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: Design.zero)
        ])
        
        rightNavButton.constrain([
            rightNavButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: Design.margin18),
            rightNavButton.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -Design.margin24),
            rightNavButton.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -Design.margin15),
            rightNavButton.heightAnchor.constraint(equalToConstant: Design.heightWidth48)
        ])
        rightBtnWidthConstraint = rightNavButton.widthAnchor.constraint(equalToConstant: Design.margin48)
        rightBtnWidthConstraint?.isActive = true
        
    }
    
    public func setNavigationBar(title: String, desc: String? = "", isBack: Bool? = false, leftIcon: ImageName = .icBack , rightButton: String? = "", profilePicture: String? = "") {
        navBar.isHidden = false
        if (desc ?? "").isEmpty {
            navDescLabel.isHidden = true
            navTitleLabel.setTheme(.navDashTitle)
        }
        if isBack ?? false {
            leftNavButton.setImage(UIImage(named: leftIcon.rawValue), for: .normal)
            widthConstraint?.constant = Design.margin24
            leftNavButton.isHidden = false
            leftNavButton.layer.cornerRadius = Design.zero
        } else if let value = profilePicture, !value.isEmpty {
            if let imageURL = URL(string: value) {
                let imageView = UIImageView()
                leftNavButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(named: ImageName.icProfile.rawValue))
            }
            widthConstraint?.constant = Design.heightWidth48
        } else {
            leftNavButton.isHidden = true
            widthConstraint?.constant = Design.zero
            titleView.constrain([
                titleView.leftAnchor.constraint(equalTo: leftNavButton.rightAnchor, constant: -Design.margin6)
            ])
        }
        
        if let value = rightButton, !value.isEmpty {
            rightNavButton.isHidden = false
            rightNavButton.setImage(UIImage(named: value), for: .normal)
            rightBtnWidthConstraint?.constant = Design.heightWidth48
        } else {
            rightNavButton.isHidden = true
            rightBtnWidthConstraint?.constant = Design.zero
        }
        
        navTitleLabel.text = title
        navDescLabel.text = desc
    }
    
    public func hideNavigationBar() {
        navBar.isHidden = true
    }

    public func showNavigationBar() {
        navBar.isHidden = false
    }
    
    public func navbarBottomAnchor() -> NSLayoutYAxisAnchor {
        return stackView.bottomAnchor
    }
    
    public func setThemeForBlackBackground() {
        view.backgroundColor = .black
        stackView.backgroundColor = .black
        navBar.backgroundColor = .black
        titleView.backgroundColor = .black
        navStackView.backgroundColor = .black
        
        navTitleLabel.setColor(color: .white)
    }
    
    @objc func onClickLeftButton(sender: UIButton) {
        
    }
    
    @objc func onClickRightButton(sender: UIButton) {
        
    }
}
