//
//  Employees.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 18.02.2023.
//

import Foundation

//MARK: - Departaments
enum Departaments: String, CaseIterable {
    case android = "Android"
    case ios = "iOS"
    case design = "Designers"
    case management = "Managers"
    case qa = "QA"
    case back_office = "Back office"
    case frontend = "Frontend"
    case hr = "HR"
    case pr = "PR"
    case backend = "Backend"
    case support = "Support"
    case analytics = "Analytics"
}

// MARK: - EmployeesData
struct Users: Codable {
    let items: [User]
}

// MARK: - User
struct User: Codable {
    let id: String
    let firstName, lastName, department: String
    let position, birthday, phone: String
    var userTag, avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
}

//typealias Users = [User]
