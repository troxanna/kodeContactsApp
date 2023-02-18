//
//  Employees.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 18.02.2023.
//

import Foundation

// MARK: - EmployeesData
struct EmployeesData: Codable {
    let items: [Person]
}

// MARK: - Person
struct Person: Codable {
    let id: String
    let avatarURL: String
    let firstName, lastName, userTag, department: String
    let position, birthday, phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
}
