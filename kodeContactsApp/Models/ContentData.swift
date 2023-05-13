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

enum SortedBottomSheetData {
    case sorting
    
    var text: String {
        switch self {
        case .sorting:
            return String.localize("Sorting")
        }
    }
}

