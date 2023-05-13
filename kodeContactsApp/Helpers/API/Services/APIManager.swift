//
//  APIManager.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 05.03.2023.
//

import Foundation

enum ApiType {
    case getUsers
    case getUsersError
    case getUsersSuccess
    
    var baseURL: String {
        return "https://stoplight.io/mocks/kode-education/trainee-test/25143926/"
    }
    
    var headers: [String : String] {
        switch self {
        case .getUsers:
            return ["Content-Type": "application/json", "Prefer":"code=200, dynamic=true"]
        case .getUsersError:
            return ["Content-Type": "application/json", "Prefer":"code=500, example=error-500"]
        case .getUsersSuccess:
            return ["Content-Type": "application/json", "Prefer":"code=200, example=success"]
        }
        
        //code=200, example=success
        //code=200, dynamic=true
        //code=500, example=error-500
    }
    
    var path: String {
        switch self {
        case .getUsers, .getUsersError, .getUsersSuccess:
            return "users"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
        case .getUsers, .getUsersSuccess, .getUsersError:
            request.httpMethod = "GET"
            return request
        }
    }
}

class APIManager {
    static let shared = APIManager()
    
    func getUsers(completion: @escaping (_: () throws -> [User]) -> ())  {
        let request = ApiType.getUsers.request
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion({
                if error != nil {
                    throw AppError.unexpectedError
                }
                guard let data = data else { throw AppError.emptyDataError }
                if (try? JSONDecoder().decode(ErrorInfo.self, from: data)) != nil {
                    throw AppError.internalServerError
                }
                guard let users = try? JSONDecoder().decode(Users.self, from: data) else { throw AppError.validationError
                }
                try self.validationValueDepartment(users: users.items)
                return users.items
            })
        }.resume()
    }
}

//MARK: Validation functions
extension APIManager {
    private func validationValueDepartment(users: [User]) throws {
        for item in users {
            guard let _ = Departments(rawValue: item.department) else {
                throw AppError.validationError
            }
        }
    }
}
