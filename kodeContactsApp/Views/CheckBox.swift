//
//  CheckBox.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 20.03.2023.
//

import UIKit

class CheckBox: UIButton {
    
    private let checkedImage = UIImage(named: Icons.checkBoxActive.rawValue)! as UIImage
    private let uncheckedImage = UIImage(named: Icons.checkBoxInactive.rawValue)! as UIImage
        
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
            
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: Color.richBlack.rawValue), for: .normal)
        self.titleLabel?.font = UIFont(name: Font.interMedium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        self.setTitleInsets(imageTitlePadding: 14)
    }
}
