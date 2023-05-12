//
//  UpdateErrorViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 09.05.2023.
//

import UIKit

class InternetConnectionErrorViewController: UIViewController {
    private let errorView: InternetConnectionErrorView = {
        let view = InternetConnectionErrorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupPanGesture()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

private extension InternetConnectionErrorViewController {
    func setup() {
        self.definesPresentationContext = true
        view.alpha = 1.0

        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UINavigationController.navigationBarHeight())
        }
    }
    
    func setupPanGesture() {
        let gestureViewTap = UITapGestureRecognizer(target: self, action: #selector(didViewTap))
        errorView.addGestureRecognizer(gestureViewTap)
    }
    
    @objc func didViewTap() {
        self.dismiss(animated: true)
    }
}
