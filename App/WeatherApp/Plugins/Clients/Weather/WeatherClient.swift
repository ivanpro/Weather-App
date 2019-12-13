//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import Alamofire

private struct Endpoints {
    static let weather: String = "https://api.openweathermap.org/data/2.5/weather?q="
    static let icon: String = ""
}

private struct Units {
    static let metric = "&units=metric"
    static let imperial = "&units=imperial"
}

let apiKey = "&appid=95d190a434083879a6398aafd54d9e73"

final class WeatherClient: WeatherClientInterface {
    private let fetchQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_fetch_queue", qos: .utility, attributes: .concurrent)
    private let iconQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_icon_queue", qos: .utility, attributes: .concurrent)

    func fetchWatherForLocation(_ location: String, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        let url = Endpoints.weather + location + apiKey + Units.metric

        fetchQueue.async {
            request(url).responseJSON { response in
                DispatchQueue.main.async {
                    self.parseResponse(response: response, onSuccess: onSuccess, onError: onError)
                }
            }
        }
    }
}

extension WeatherClient {
    // MARK: - Helpers
    func parseResponse(response: DataResponse<Any>, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        DispatchQueue.main.async {
            guard response.error == nil else { return self.parseErrorResponse(response: response, onError: onError) }

            guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? JSONDictionary else {

                let error = NSError(domain: "Failed to parse JSON object", code: 0, userInfo: nil)
                onError?(0, nil, error)
                return
            }

            self.parseSuccessResponse(json, onSuccess: onSuccess)
        }
    }

    func parseSuccessResponse(_ response: JSONDictionary, onSuccess: ((JSONDictionary) -> Void)?) {
        onSuccess?(response)
    }

    func parseErrorResponse(response: DataResponse<Any>, onError: HttpErrorClosure?) {
        onError?(response.response?.statusCode, response.value as? JSONDictionary, response.error)
    }
}
