//
//  CheckBoxControl.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 31.03.2023.
//

import UIKit



class CheckBoxControl: UIView {
    
    weak var delegate: CheckBoxControlDelegate?
    
    private let buttonAlpha: CheckBox = {
        let button = CheckBox(title: SortedType.alphabetically.text)
        button.addTarget(self, action: #selector(buttonClickedSelected), for: .touchUpInside)
        button.isChecked = false
        return button
    }()
    
    private let buttonBirthday: CheckBox = {
        let button = CheckBox(title: SortedType.birthday.text)
        button.addTarget(self, action: #selector(buttonClickedSelected), for: .touchUpInside)
        button.isChecked = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: private functions
private extension CheckBoxControl {
    func setup() {
        configurationButton()
    }
    
    func configurationButton() {
        addSubview(buttonAlpha)
        addSubview(buttonBirthday)
        
        buttonAlpha.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalTo(self.snp.top).inset(20)
            make.left.equalTo(self.snp.left)
        }
        buttonBirthday.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalTo(buttonAlpha.snp.bottom).offset(36)
            make.bottom.equalTo(self.snp.bottom).inset(20)
            make.left.equalTo(self.snp.left)
        }
    }
}

//MARK: public functions
extension CheckBoxControl {
    func getActiveSortedType() -> SortedType {
        if buttonAlpha.isChecked == true {
            return SortedType.alphabetically
        }
        return SortedType.birthday
    }
    
    func setActiveSortedType(sortedType: SortedType) {
        if sortedType == SortedType.alphabetically {
            buttonAlpha.isChecked = true
            buttonBirthday.isChecked = false
        } else if sortedType == SortedType.birthday {
            buttonBirthday.isChecked = true
            buttonAlpha.isChecked = false
        }
    }
    
    @objc func buttonClickedSelected(sender: CheckBox) {
        if sender == buttonAlpha && buttonAlpha.isChecked == false {
            buttonAlpha.isChecked = true
            buttonBirthday.isChecked = false
        }
        else if sender == buttonBirthday && buttonBirthday.isChecked == false {
            buttonBirthday.isChecked = true
            buttonAlpha.isChecked = false
        }
        delegate?.animateDismissView(isNeededSorting: true)
    }
}
