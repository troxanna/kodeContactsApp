//
//  ErrorViewController.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 01.03.2023.
//

import UIKit

class ErrorViewController: UIViewController {
    
    private let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let messageErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let buttonRepeatRequest: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private let imageError: UIImageView = {
        let image = UIImageView()
        return image
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        configuratedErrorView()
        contentConfiguratedErrorView()
    }
    
}

//MARK: Private functions
extension ErrorViewController {
    private func configuratedErrorView() {
        let errorStack = UIStackView()
        errorStack.axis = .vertical
        errorStack.spacing = 12
        errorStack.alignment = .center
        
        errorStack.addArrangedSubview(imageError)
        errorStack.addArrangedSubview(titleErrorLabel)
        errorStack.addArrangedSubview(messageErrorLabel)
        errorStack.addArrangedSubview(buttonRepeatRequest)
        
        view.addSubview(errorStack)
        
        errorStack.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(56)
        })
        
    }
    
    private func contentConfiguratedErrorView() {
        imageError.image = UIImage(named: "flyingSaucer")
        titleErrorLabel.text = "Какой-то сверхразум все сломал"
        messageErrorLabel.text = "Постараемся быстро починить"
        buttonRepeatRequest.setTitle("Попробовать снова", for: .normal)
        
    }
}
