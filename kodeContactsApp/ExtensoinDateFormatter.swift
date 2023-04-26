//
//  ExtensoinDateFormatter.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 03.04.2023.
//

import Foundation

extension DateFormatter {
    func getDateString(dateFormat: String, date: String) -> (String) {
        self.dateFormat = "yyyy-MM-dd"
        let dateString = self.date(from: date)
        self.dateFormat = dateFormat
        guard let dateStringFormat = dateString else {
            return ""
        }
        let date = self.string(from: dateStringFormat)
        return date
    }
    
    func getMonth(date: String) -> Int {
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: date)
        if let month = date?.monthInt {
            return month
        }
        return 0
    }
    
    func getCurrentMonth(date: String) -> Int {
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: date)
        if let month = date?.monthInt {
            return month
        }
        return 0
    }
    
    func getDay(date: String) -> Int {
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: date)
        if let day = date?.dayInt {
            return day
        }
        return 0
    }
    
    func getCurrentDay(date: String) -> Int {
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: date)
        if let day = date?.dayInt {
            return day
        }
        return 0
    }
}
