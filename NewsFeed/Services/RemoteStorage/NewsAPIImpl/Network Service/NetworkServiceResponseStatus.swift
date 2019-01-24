//
//  NetworkResponseStatus.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

public enum NetworkResponseStatus<SuccessType, ErrorType> {
    case Success(SuccessType?)
    case Error(NetworkError, ErrorType?)
}
