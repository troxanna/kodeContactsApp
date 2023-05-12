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
        returnKeyType = .default
        backgroundColor = UIColor(named: Color.white.rawValue)
        
        
        setRightImage(imageName: Icons.sortInactive.rawValue, offset: UIOffset(horizontal: -8, vertical: 0))
        setLeftImage(imageName: Icons.searchInactive.rawValue, offset: UIOffset(horizontal: 8, vertical: 0))
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
        searchTextField.backgroundColor = UIColor(named: Color.cultured.rawValue)
        searchTextField.layer.cornerRadius = 16
        searchTextField.clipsToBounds = true
        searchTextPositionAdjustment = offset
        
        configurationPlaceholder()
        configurationInputText()
    }
    
    func configurationPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: Color.silverSand.rawValue),
            .font: UIFont(name: Font.interMedium.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: SearchTextFieldData.placeholder.text, attributes: attributes)
    }
    
    func configurationInputText() {
        searchTextField.tintColor = UIColor(named: Color.hanPurple.rawValue)
        searchTextField.font = UIFont(name: Font.interMedium.rawValue, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        searchTextField.textColor = UIColor(named: Color.richBlack.rawValue)
    }
    
    func configurationCancelPutton() {
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: Color.hanPurple.rawValue),
            .font: UIFont(name: Font.interSemiBold.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = SearchTextFieldData.cancelButtonTitle.text
    }
}

//MARK: public functions
extension SearchBar {
    func setSortedIcon(for state: Icons) {
        setImage(imageName: state.rawValue, offset: UIOffset(horizontal: -8, vertical: 0), type: .bookmark)
    }
    
    func setSearchIcon(for state: Icons) {
        setImage(imageName: state.rawValue, offset: UIOffset(horizontal: 8, vertical: 0), type: .search)
    }
}
