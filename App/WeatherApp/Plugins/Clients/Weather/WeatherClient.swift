//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Alamofire
import AlamofireImage

final class WeatherClient: WeatherClientInterface {
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )

    private let fetchQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_fetch_queue", qos: .utility, attributes: .concurrent)
    private let iconQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_icon_queue", qos: .utility, attributes: .concurrent)

    func fetchWatherForLocation(_ location: String, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        let url = Endpoints.weather + location + WeatherClient.apiKey + Units.metric

        fetchQueue.async {
            request(url).responseJSON { [weak self] response in
                DispatchQueue.main.async {
                    self?.parseResponse(response: response, onSuccess: onSuccess, onError: onError)
                }
            }
        }
    }

    func fetchIconForWeather(_ iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?) {
        let url = Endpoints.icon + iconId + Endpoints.iconType

        if let image = imageCache.image(withIdentifier: url),
            let data = convertImageData(image) {

            onSuccess?(data)
            return
        }

        iconQueue.async {
            request(url).responseImage { [weak self] response in
                guard let image = response.result.value else {
                    self?.parseErrorResponse(error: response.error?.localizedDescription, onError: onError)
                    return
                }

                self?.imageCache.add(image, withIdentifier: url)

                guard let data = self?.convertImageData(image) else {
                    self?.parseErrorResponse(error: response.error?.localizedDescription, onError: onError)
                    return
                }

                onSuccess?(data)
            }
        }
    }
}

extension WeatherClient {
    // MARK: - Helpers
    func convertImageData(_ image: Image) -> Data? {
        return image.jpegData(compressionQuality: 70.0)
    }

    func parseResponse(response: DataResponse<Any>, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        DispatchQueue.main.async {
            guard response.error == nil else {
                self.parseErrorResponse(error: response.error?.localizedDescription, onError: onError)
                return
            }

            guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? JSONDictionary else {
                self.parseErrorResponse(error: "Failed to parse JSON object", onError: onError)
                return
            }

            self.parseSuccessResponse(json, onSuccess: onSuccess)
        }
    }

    func parseSuccessResponse(_ response: JSONDictionary, onSuccess: ((JSONDictionary) -> Void)?) {
        onSuccess?(response)
    }

    func parseErrorResponse(error: String?, onError: HttpErrorClosure?) {
        onError?(error ?? WeatherClient.unknownErrorMessage)
    }
}
