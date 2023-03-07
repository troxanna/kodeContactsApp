//
//  APIManager.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 05.03.2023.
//

import Foundation

enum ApiType {
    case getUsers
    
    var baseURL: String {
        return "https://stoplight.io/mocks/kode-education/trainee-test/25143926/"
    }
    
    var headers: [String : String] {
        switch self {
        case .getUsers:
            return ["Content-Type": "application/json", "Prefer":"code=200, example=success"]
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "users"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
        case .getUsers:
            request.httpMethod = "GET"
            return request
        }
    }
    
}

class APIManager {
    static let shared = APIManager()
    
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        let request = ApiType.getUsers.request
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let users = try? JSONDecoder().decode(Users.self, from: data) {
                completion(users.items)
            } else {
                completion([])
            }
        }.resume()
    }
}
