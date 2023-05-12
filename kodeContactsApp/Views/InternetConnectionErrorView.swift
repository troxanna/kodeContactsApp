//
//  UpdateErrorView.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 27.04.2023.
//

import UIKit

class InternetConnectionErrorView: UIView {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Color.white.rawValue)
        label.numberOfLines = 0
        label.text = ErrorMessage.networkError.text
        label.font = UIFont(name: Font.interMedium.rawValue, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InternetConnectionErrorView {
    func setup() {
        backgroundColor = UIColor(named: Color.coralRed.rawValue)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).inset(24)
            make.left.equalTo(self.snp.left).inset(24)
            make.bottom.equalTo(self.snp.bottom).inset(12)
        }
    }
}
