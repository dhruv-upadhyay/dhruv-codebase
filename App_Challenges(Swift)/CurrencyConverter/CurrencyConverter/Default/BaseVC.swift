//
//  BaseVC.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import UIKit
import Alamofire

class BaseVC: UIViewController {
    let navDevider = UIView()
    struct Design {
        static let buttonTitleSpace: CGFloat = 32
        static let tapArea: CGFloat = 48.0
        static let barPadding: CGFloat = 19.0
        static let imageCircleSize = CGRect(x: 8.0, y: 0, width: 40, height: 40)
        static let accessibleTapArea = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        static let navigationBarColor = UIColor.BrandColour.Navigation.white
        static let tapSize = CGSize(width: 80.0, height: 48.0)
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
    
    public func hideTabBar (_ hidden: Bool) {
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
    public func showDevider() {
        self.view.addSubview(navDevider)
        navDevider.constrain([
            navDevider.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navDevider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            navDevider.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            navDevider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        navDevider.do {
            $0.backgroundColor = UIColor.BrandColour.Border.gray
        }
    }
}
