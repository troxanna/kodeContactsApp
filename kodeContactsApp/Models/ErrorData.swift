//
//  Error.swift
//  kodeContactsApp
//
//  Created by Anastasia Nevodchikova on 08.03.2023.
//

import Foundation

struct ErrorData {
    var title: String
    var message: String
    var imageName: String
    var repeatRequest: Bool
}

struct ErrorInfo: Codable {
    let code: Int
    let key: String
}

enum ErrorMessage: String {
    case searchError
    case criticalError
    case networkError
    
    var text: String {
        switch self {
        case .searchError:
            return String.localize("error_message.search_error")
        case .criticalError:
            return String.localize("error_message.critical_error")
        case .networkError:
            return String.localize("error_message.network_error")
        }
        
    }
}

enum ErrorTitle: String {
    case searchError
    case criticalError
    
    var text: String {
        switch self {
        case .searchError:
            return String.localize("error_title.search_error")
        case .criticalError:
            return String.localize("error_title.critical_error")
        }
        
    }
}

enum ScreenError {
    case searchError
    case criticalError
    
    var errorView: ErrorView {
        switch self {
        case .searchError:
            return ErrorView(frame: .zero, errorDescription: ErrorData(title: ErrorTitle.searchError.text, message: ErrorMessage.searchError.text, imageName: Icons.searchError.rawValue, repeatRequest: false))
        case .criticalError:
            return ErrorView(frame: .zero, errorDescription: ErrorData(title: ErrorTitle.criticalError.text, message: ErrorMessage.criticalError.text, imageName: Icons.flyingSaucer.rawValue, repeatRequest: true))
        }
    }
}

enum AppError: Error {
    case validationError
    case searchError
    case emptyDataError
    case internalServerError
    case unexpectedError
//  case networkError
//  case fetchImageError
}
