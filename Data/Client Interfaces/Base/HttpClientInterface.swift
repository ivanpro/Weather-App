//
//  HttpClientInterface.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]
typealias HttpSuccessClosure = ((_ responseDictionary: JSONDictionary?) -> Void)
typealias HttpErrorClosure = ((_ errorMessage: String) -> Void)
