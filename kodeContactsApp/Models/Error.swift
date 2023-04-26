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

enum ScreenError {
    case searchError
    case criticalError
    
    var errorView: ErrorView {
        switch self {
        case .searchError:
            return ErrorView(frame: .zero, errorDescription: ErrorData(title: "Мы никого не нашли", message: "Попробуй скорректировать запрос", imageName: "searchError", repeatRequest: false))
        case .criticalError:
            return ErrorView(frame: .zero, errorDescription: ErrorData(title: "Какой-то сверхразум все сломал", message: "Постараемся быстро починить", imageName: "flyingSaucer", repeatRequest: true))
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
