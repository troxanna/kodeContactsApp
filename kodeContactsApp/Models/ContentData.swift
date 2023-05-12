//
//  ContentData.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 12.05.2023.
//

import Foundation

enum SearchTextFieldData {
    case placeholder
    case cancelButtonTitle
    
    var text: String {
        switch self {
        case .placeholder:
            return String.localize("Enter name, tag, email...")
        case .cancelButtonTitle:
            return String.localize("Cancel")
        }
    }
}

enum NumberPhoneAlertData {
    case cancelButtonTitle
    
    var text: String {
        switch self {
        case .cancelButtonTitle:
            return String.localize("Cancel")
        }
    }
}

enum SortedType {
    case alphabetically
    case birthday
    
    var text: String {
        switch self {
        case .alphabetically:
            return String.localize("By alphabetically")
        case .birthday:
            return String.localize("By birthday")
        }
    }
}

enum SortedBottomSheetData {
    case sorting
    
    var text: String {
        switch self {
        case .sorting:
            return String.localize("Sorting")
        }
    }
}

