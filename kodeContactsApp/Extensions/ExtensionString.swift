//
//  ExtensionString.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 12.05.2023.
//

import Foundation

extension String {
    static func localize(_ text: String) -> String {
        if #available(iOS 15, *) {
            return String(localized: LocalizationValue(text))
        } else {
            return NSLocalizedString(text, comment: "")
        }
    }
}
