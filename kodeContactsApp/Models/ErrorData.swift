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
            return String.localize("Try to edit your request")
        case .criticalError:
            return String.localize("We'll try to fix it quickly")
        case .networkError:
            return String.localize("Can't update data.\nCheck your internet connection.")
        }
        
    }
}

enum ErrorTitle: String {
    case searchError
    case criticalError
    
    var text: String {
        switch self {
        case .searchError:
            return String.localize("We didn't find anyone")
        case .criticalError:
            return String.localize("Some super intelligence broke everything")
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
