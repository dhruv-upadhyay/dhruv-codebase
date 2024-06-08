//
//  SplashVC.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

class SplashVC: BaseVC {
    
    private let imgLogo = UIImageView()
    private let loaderView = LoadingView(type: .normal, height: 20, width: 20)
    private let viewModel = SplashViewModel()
    
    struct Design {
        static let zero: CGFloat = 0
        static let logoWidth: CGFloat = 200
        static let logoHeight: CGFloat = 155
        static let loaderTopMargin: CGFloat = 10
        static let loaderSize: CGFloat = 20
    }
    
    override func viewDidLoad() {
        setTheme()
        doLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.canAPICallAgain() {
            loaderView.isHidden = false
            loaderView.startLoading()
            viewModel.callCurrencyRateAPI { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.redirectToNext()
                strongSelf.loaderView.stopAnimation()
            }
        } else {
            viewModel.setFromRealmData()
            if viewModel.isDataAreAvailable() {
                redirectToNext()
            } else {
                showErrorPopup(title: viewModel.getErrorData().title, message: viewModel.getErrorData().message)
            }
        }
    }
    
    private func redirectToNext() {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let vc = LandingPageVC()
            vc.viewModel.setData(data: viewModel.getAllData())
            delegate.window?.rootViewController = UINavigationController(rootViewController: vc)
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    private func setTheme() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.BrandColour.Custom.gunmetal
        imgLogo.image = UIImage(named: ImageName.icLogo.rawValue)
        loaderView.do {
            $0.backgroundColor = .clear
            $0.isHidden = true
        }
    }
    
    private func doLayout() {
        view.addSubviews([imgLogo, loaderView])
        imgLogo.constrain([
            imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: Design.zero),
            imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Design.zero),
            imgLogo.widthAnchor.constraint(equalToConstant: Design.logoWidth),
            imgLogo.heightAnchor.constraint(equalToConstant: Design.logoHeight)
        ])
        
        loaderView.constrain([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: Design.zero),
            loaderView.topAnchor.constraint(equalTo: imgLogo.bottomAnchor, constant: Design.loaderTopMargin),
            loaderView.heightAnchor.constraint(equalToConstant: Design.loaderSize),
            loaderView.widthAnchor.constraint(equalToConstant: Design.loaderSize)
        ])
    }
}
