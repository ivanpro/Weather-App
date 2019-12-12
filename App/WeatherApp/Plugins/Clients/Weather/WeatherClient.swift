//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import Alamofire

final class WeatherClient: WeatherClientInterface {
    func fetchWatherForLocation(_ location: String, onSuccess: ((String) -> Void)?, onError: HttpErrorClosure?) {
        request("https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=95d190a434083879a6398aafd54d9e73").responseJSON { response in
            debugPrint(response)
        }
    }
}
