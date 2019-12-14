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
            request(url).responseJSON { [weak self] dataResponse in
                DispatchQueue.main.async {
                    self?.parseResponse(response: dataResponse, onSuccess: onSuccess, onError: onError)
                }
            }
        }
    }

    func fetchIconForWeather(_ iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?) {
        let url = Endpoints.icon + iconId + Endpoints.iconType

        // Fetch image from cache first
        if let imageData = fetchImageFromCache(for: url) {
            onSuccess?(imageData)
            return
        }

        iconQueue.async {
            request(url).responseImage { [weak self] dataResponse in
                guard let image = dataResponse.result.value else {
                    self?.parseErrorResponse(error: dataResponse.error?.localizedDescription, onError: onError)
                    return
                }

                guard let data = self?.convertImageData(image) else {
                    self?.parseErrorResponse(error: dataResponse.error?.localizedDescription, onError: onError)
                    return
                }

                // Cache the image
                if let request = dataResponse.request {
                    self?.imageCache.add(image, for: request)
                }

                onSuccess?(data)
            }
        }
    }
}

extension WeatherClient {
    // MARK: - Helpers
    func fetchImageFromCache(for requestUrl: String) -> Data? {
        guard let url = URL(string: requestUrl),
            let image = imageCache.image(for: URLRequest(url: url)),
            let data = convertImageData(image) else { return nil}

        return data
    }

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

            guard json.string(forKey: "cod") != "200", let message = json.string(forKey: "message") else {
                self.parseSuccessResponse(json, onSuccess: onSuccess)
                return
            }

            onError?(message)
        }
    }

    func parseSuccessResponse(_ response: JSONDictionary, onSuccess: ((JSONDictionary) -> Void)?) {
        onSuccess?(response)
    }

    func parseErrorResponse(error: String?, onError: HttpErrorClosure?) {
        onError?(error ?? WeatherClient.unknownErrorMessage)
    }
}
