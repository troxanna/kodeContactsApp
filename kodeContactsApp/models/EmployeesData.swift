//
//  Employees.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 18.02.2023.
//

import Foundation

//MARK: - Departaments
enum Departaments: String, CaseIterable {
    case all
    case android
    case ios
    case design
    case management
    case qa
    case back_office
    case frontend
    case hr
    case pr
    case backend
    case support
    case analytics
    
    var value: String {
        switch self {
        case .all:
            return "Все"
        case .android:
            return "Android"
        case .ios:
            return "iOS"
        case .design:
            return "Designers"
        case .management:
            return "Managers"
        case .qa:
            return "QA"
        case .back_office:
            return "Back office"
        case .frontend:
            return "Frontend"
        case .hr:
            return "HR"
        case .pr:
            return "PR"
        case .backend:
            return "Backend"
        case .support:
            return "Support"
        case .analytics:
            return "Analytics"
        }
    }
    
    static var departments: [String] {
        var array: [String] = []
        for item in Departaments.allCases {
            array.append(item.value)
        }
        return array
    }
}


// MARK: - EmployeesData
struct Users: Codable {
    let items: [User]
}

// MARK: - User
//Equatable
struct User: Codable, Equatable {
    let id: String
    let firstName, lastName, department: String
    let position, birthday, phone: String
    var userTag, avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

//typealias Departments = [String]
