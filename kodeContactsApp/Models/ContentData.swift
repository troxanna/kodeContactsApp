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
            return String.localize("search_text_field_data.placeholder")
        case .cancelButtonTitle:
            return String.localize("search_text_field_data.cancel_button_title")
        }
    }
}

enum NumberPhoneAlertData {
    case cancelButtonTitle
    
    var text: String {
        switch self {
        case .cancelButtonTitle:
            return String.localize("number_phone_alert_data.cancel_button_title")
        }
    }
}

enum SortedBottomSheetData {
    case sorting
    
    var text: String {
        switch self {
        case .sorting:
            return String.localize("sorted_bottom_sheet_data.sorting")
        }
    }
}

