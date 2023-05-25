//
//  Employees.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 18.02.2023.
//

import Foundation

//MARK: - Departments
enum Departments: String, CaseIterable {
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
            return String.localize("departments.all")
        case .android:
            return String.localize("departments.android")
        case .ios:
            return String.localize("departments.ios")
        case .design:
            return String.localize("departments.designers")
        case .management:
            return String.localize("departments.managers")
        case .qa:
            return String.localize("departments.qa")
        case .back_office:
            return String.localize("departments.back_office")
        case .frontend:
            return String.localize("departments.frontend")
        case .hr:
            return String.localize("departments.hr")
        case .pr:
            return String.localize("departments.pr")
        case .backend:
            return String.localize("departments.backend")
        case .support:
            return String.localize("departments.support")
        case .analytics:
            return String.localize("departments.analytics")
        }
    }
    
    static var departments: [String] {
        var array: [String] = []
        for item in Departments.allCases {
            array.append(item.value)
        }
        return array
    }
}


// MARK: - Users
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
