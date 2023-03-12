//
//  SearchBar.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 11.03.2023.
//

import UIKit

class SearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: private functions
private extension SearchBar {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.returnKeyType = .default
        
        setRightImage(imageName: Icons.sort.rawValue, offset: UIOffset(horizontal: -8, vertical: 0))
        setLeftImage(imageName: Icons.search.rawValue, offset: UIOffset(horizontal: 8, vertical: 0))
        setClearImage(imageName: Icons.clear.rawValue, offset: UIOffset(horizontal: -8, vertical: 0))
        
        configurationText(offset: UIOffset(horizontal: 4, vertical: 0))
        configurationCancelPutton()
    }
    
    func setRightImage(imageName: String, offset: UIOffset) {
        showsBookmarkButton = true
        setImage(imageName: imageName, offset: offset, type: .bookmark)
        searchTextField.rightViewMode = .always
    }
    
    func setLeftImage(imageName: String, offset: UIOffset) {
        setImage(imageName: imageName, offset: offset, type: .search)
        searchTextField.leftViewMode = .always
    }
    
    func setClearImage(imageName: String, offset: UIOffset) {
        setImage(imageName: imageName, offset: offset, type: .clear)
    }
    
    func setImage(imageName: String, offset: UIOffset, type: UISearchBar.Icon) {
        setImage(UIImage(named: imageName), for: type, state: .normal)
        setImage(UIImage(named: imageName), for: type, state: .highlighted)
        setPositionAdjustment(offset, for: type)
    }
    
    func configurationText(offset: UIOffset) {
        searchTextField.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        searchTextField.layer.cornerRadius = 16
        searchTextField.clipsToBounds = true
        searchTextPositionAdjustment = offset
        
        configurationPlaceholder()
        configurationInputText()
    }
    
    func configurationPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 195/255, green: 195/255, blue: 198/255, alpha: 1),
            .font: UIFont(name: "Inter-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: SearchTextFieldData.placeholder.rawValue, attributes: attributes)
    }
    
    func configurationInputText() {
        searchTextField.tintColor = UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1)
        searchTextField.font = UIFont(name: "Inter-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        searchTextField.textColor = UIColor(red: 5/255, green: 5/255, blue: 16/255, alpha: 1)
    }
    
    func configurationCancelPutton() {
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 101/255, green: 52/255, blue: 255/255, alpha: 1),
            .font: UIFont(name: "Inter-Semibold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = SearchTextFieldData.cancelButtonTitle.rawValue
    }
}
