//
//  ErrorView.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 08.03.2023.
//

import UIKit

class ErrorView: UIView {
    
    //MARK: Private properties
    weak var delegate: ErrorViewDelegate?
    
    private let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.richBlack.rawValue)
        label.font = UIFont(name: Font.interSemiBold.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let messageErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.spanishGray.rawValue)
        label.font = UIFont(name: Font.interRegular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let buttonRepeatRequest: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: Color.white.rawValue)
        button.setTitleColor(UIColor(named: Color.hanPurple.rawValue), for: .normal)
        button.titleLabel?.font = UIFont(name: Font.interSemiBold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        button.addTarget(self, action: #selector(buttonRepeatRequestPressed), for: .touchUpInside)
        return button
    }()
    
    private let imageError: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    //MARK: init
    init(frame: CGRect, errorDescription: ErrorData) {
        super.init(frame: frame)
        configurationErrorView(repeatRequest: errorDescription.repeatRequest)
        contentConfigurationErrorView(errorDescription: errorDescription)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Private functions
extension ErrorView {
    private func configurationErrorView(repeatRequest: Bool) {
        let errorStack = UIStackView()
        errorStack.axis = .vertical
        errorStack.spacing = 12
        errorStack.alignment = .center
        
        errorStack.addArrangedSubview(imageError)
        errorStack.addArrangedSubview(titleErrorLabel)
        errorStack.addArrangedSubview(messageErrorLabel)
        
        if (repeatRequest == true) {
            errorStack.addArrangedSubview(buttonRepeatRequest)
        }
        
        self.addSubview(errorStack)
        
        errorStack.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        titleErrorLabel.snp.makeConstraints({ make in
            make.top.equalTo(imageError.snp.bottom).offset(8)
        })
    }
    
    private func contentConfigurationErrorView(errorDescription: ErrorData) {
        imageError.image = UIImage(named: errorDescription.imageName)
        titleErrorLabel.text = errorDescription.title
        messageErrorLabel.text = errorDescription.message
        if errorDescription.repeatRequest == true {
            buttonRepeatRequest.setTitle("Попробовать снова", for: .normal)
        }
    }
    
    
    @objc private func buttonRepeatRequestPressed() {
        //после подключения API вызвать запрос списка контактов тут
        self.removeFromSuperview()
        self.delegate?.buttonRepeatRequestPressed()
    }

}
