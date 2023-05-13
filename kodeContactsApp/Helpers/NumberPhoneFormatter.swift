//
//  NumberPhoneFormatter.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 13.05.2023.
//

import Foundation

final class NumberPhoneFormatter {
    static func formatPhoneNumber(number: String) -> String {
        let mask = PhoneNumberFormat.ru.rawValue
        var result = ""
        var index = number.startIndex
        for ch in mask where index < number.endIndex {
            if number[index] == "-" {
                result.append(ch)
                index = number.index(after: index)
            }
            else if ch == "X" {
                result.append(number[index])
                index = number.index(after: index)
            }
            else {
                result.append(ch)
            }
        }
        return result
    }
    
    static func removeNumberFormat(number: String) -> String {
        let digits = CharacterSet.decimalDigits
        var text = ""
        for char in number.unicodeScalars {
            if digits.contains(char) {
                text.append(char.description)
            }
        }
        return text
    }
}
