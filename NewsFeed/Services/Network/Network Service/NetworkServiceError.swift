//
//  NetworkServiceError.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case MissingRequaredParameter(String)
    case MissingRequaredHeader(String)
    case InvalidURL(String?)
    case InvalidResponse(URLResponse?)
    case ResponseError(Int)
    case UnknownError(Error)
    
    //FIXME: NSLocalizedString
    var localizedDescription: String {
        switch self {
        case .MissingRequaredParameter(let parameter):
            return "Отсутствует обязательный параметр \(parameter)"
        case .MissingRequaredHeader(let header):
            return "Отсутствует обязательный заголовок \(header)"
        case.InvalidURL(let urlString):
            if let urlString = urlString {
                return "Некорректный запрос \(urlString)"
            } else {
                return "Не удалось создать URL"
            }
        case .InvalidResponse(let response):
            if let response = response {
                return "Некорректый ответ сервера \(response)"
            } else {
                return "Не удалось получить ответ"
            }
        case .ResponseError(let status):
            return "Запрос завершен с ошибкой: \(status)"
        case .UnknownError(let error):
            return "Не удалось отправить запрос\n\(error)"
        }
    }
}
