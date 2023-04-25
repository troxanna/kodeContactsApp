//
//  Image.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 12.03.2023.
//

import Foundation

enum Icons: String {
    case star, phone, avatarURL, arrowBack, search, sortActive, sortInactive, clear, checkBoxActive, checkBoxInactive
}

enum SearchTextFieldData: String {
    case placeholder = "Введи имя, тег, почту..."
    case cancelButtonTitle = "Отмена"
}

enum SortedType: String {
    case alphabetically = "По алфавиту"
    case birthday = "По дню рождения"
}

//enum Fonts {
//    
//}

enum AnimationType: String {
    case fill
    case spinner
}
