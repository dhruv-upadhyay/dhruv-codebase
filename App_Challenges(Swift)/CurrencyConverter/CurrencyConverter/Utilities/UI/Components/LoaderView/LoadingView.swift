//
//  LoadingView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

class LoadingView: UIView {
    
    static let shared = LoadingView()
    private var loaderType:LoaderType!
    private var loaderHeight:CGFloat!
    private var loaderWidth:CGFloat!
    
    private let loadingImage = UIImageView()
    
    init(type:LoaderType? = .normal, height:CGFloat? = 100, width:CGFloat? = 100) {
        super.init(frame: UIScreen.main.bounds)
        loaderType = type
        loaderHeight = height
        loaderWidth = width
        
        setTheme()
        doLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        
        loadingImage.do {
            $0.image = UIImage(named: ImageName.icLoader.rawValue)
            $0.contentMode = .scaleAspectFill
        }
        
        if loaderType == .normal {
            self.do {
                $0.backgroundColor = .black.withAlphaComponent(0.5)
            }
        }
    }
    
    private func doLayout() {
        addSubview(loadingImage)
        loadingImage.constrain([
            loadingImage.heightAnchor.constraint(equalToConstant: loaderHeight),
            loadingImage.widthAnchor.constraint(equalToConstant: loaderWidth),
            loadingImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            loadingImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ])
    }
    
    func startLoading(sceneWindow: UIWindow? = nil) {
        if loaderType == .normal {
            let window = sceneWindow ?? UIWindow.getKeyWindow()
            window?.addSubview(self)
            window?.bringSubviewToFront(self)
        }

        DispatchQueue.main.async(execute: { [weak self] in
            self?.startAnimation()
        })
    }
    
    private func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation").then {
            $0.fromValue = 0.0
            $0.toValue = CGFloat(Double.pi * 2)
            $0.isRemovedOnCompletion = false
            $0.duration = 2
            $0.repeatCount=Float.infinity
        }
        loadingImage.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopAnimation() {
        loadingImage.layer.removeAllAnimations()
        if loaderType == .normal {
            self.removeFromSuperview()
        }
    }
}
