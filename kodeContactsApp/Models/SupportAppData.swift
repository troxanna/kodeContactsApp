//
//  SupportAppData.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 10.05.2023.
//

import Foundation

enum Icons: String {
    case star, phone, avatarURL, arrowBack, searchActive, searchInactive, sortActive, sortInactive, clear, checkBoxActive, checkBoxInactive, flyingSaucer, searchError
}

enum Font: String {
    case interMedium = "Inter-Medium"
    case interBold = "Inter-Bold"
    case interRegular = "Inter-Regular"
    case interSemiBold = "Inter-SemiBold"
}

enum AnimationType: String {
    case fill
    case spinner
}

enum Color: String {
    case hanPurple
    case cultured
    case spanishGray
    case richBlack
    case white
    case davysGrey
    case silverSand
    case antiFlashWhite
    case lotion
    case darkCharcoal
    case black
    case coralRed
}

enum DateFormat: String {
    case api = "yyyy-MM-dd"
    case viewInfo = "d MMMM y"
    case viewList = "d MMM"
}

enum PhoneNumberFormat: String {
    case ru = "+7 (XXX) XXX XX XX"
}
enum IdentifierTableViewCell: String {
    case employee = "EmployeeCell"
    case year = "YearCell"
}
