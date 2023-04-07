//
//  ExtensionDate.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 06.04.2023.
//

import Foundation

extension Date {
    var monthInt:Int {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    var dayInt:Int {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    var yearInt:Int {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year ?? 0
    }
}
