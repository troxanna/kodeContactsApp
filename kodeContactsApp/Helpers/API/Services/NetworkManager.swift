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
    
    var request: URLRequest? {
        guard let url = URL(string: path, relativeTo: URL(string: baseURL)) else { return nil }
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
    
    func getUsers(completion: @escaping (_: () throws -> [User]) -> ()) throws {
        guard let request = ApiType.getUsers.request else { throw AppError.validationError }
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

class ImageManager {
    static let shared = ImageManager()
    
    func fetchAvatarImage(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: imageUrl)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data, let response = response else {
                completion(nil)
                return
            }
            if let imageData = self.getCachedImage(from: imageUrl) {
                completion(imageData)
                return
            }
            completion(data)
            self.saveDataToCache(data: data, response: response)
        }.resume()
    }
}

//MARK: Cached functions
private extension ImageManager {
    func getCachedImage(from url: URL) -> Data? {
        let request = URLRequest(url: url)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else { return nil }
        return cachedResponse.data
    }
    
    func saveDataToCache(data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
}

