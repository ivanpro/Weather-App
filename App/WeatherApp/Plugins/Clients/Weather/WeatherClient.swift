//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Alamofire
import AlamofireImage
import EnvelopeNetwork

final class WeatherClient: WeatherClientInterface {
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )

    private let network: Networking
    private let configuration: Configuration

    struct Configuration {
        let endpointUrl: URL
        static func defaultConfiguration() -> Configuration {
            return Configuration(
                endpointUrl: URL(string: String(format: Endpoints.weather, ""))!
            )
        }
    }

    init(network: Networking = AlamofireNetwork(alamofireSessionManager: SessionManager.default),
         configuration: Configuration = Configuration.defaultConfiguration()) {
        self.network = network
        self.configuration = configuration
    }

    func fetchWatherForLocation(_ location: String, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        let url = String(format: Endpoints.weather, location)
        fetchWeather(for: url, onSuccess: onSuccess, onError: onError)
    }

    func fetchWatherForCoordinates(_ latitude: Double, longitude: Double, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        let url = String(format: Endpoints.coordinate, latitude, longitude)
        fetchWeather(for: url, onSuccess: onSuccess, onError: onError)
    }

    func fetchWeather(for url: String, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
        network.request(url, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .response(queue: DispatchQueue.main, responseSerializer: DataRequest.dataResponseSerializer(), completionHandler: { [weak self] (dataResponse: DataResponse<Data>) in
                self?.parseResponse(response: dataResponse, onSuccess: onSuccess, onError: onError)
            })
    }

    func fetchIconForWeather(_ iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?) {
        let url = String(format: Endpoints.icon, iconId)

        // Fetch image from cache first
        if let imageData = fetchImageFromCache(for: url) {
            onSuccess?(imageData)
            return
        }

        network.request(url, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .response(queue: DispatchQueue.main, responseSerializer: DataRequest.dataResponseSerializer(), completionHandler: { [weak self] (dataResponse: DataResponse<Data>) in
                self?.parseIconResponse(dataResponse: dataResponse, onSuccess: onSuccess, onError: onError)
            })
    }
}

extension WeatherClient {
    // MARK: - Helpers
    func fetchImageFromCache(for requestUrl: String) -> Data? {
        guard let url = URL(string: requestUrl),
            let image = imageCache.image(for: URLRequest(url: url)), let data = image.jpegData(compressionQuality: 70.0) else { return nil }

        return data
    }

    func convertImageData(_ imageData: Data) -> Image? {
        return Image(data: imageData)
    }

    func parseIconResponse(dataResponse: DataResponse<Data>, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?) {
        guard let imageData = dataResponse.result.value else {
            parseErrorResponse(error: dataResponse.error?.localizedDescription, onError: onError)
            return
        }

        // Cache the image
        if let request = dataResponse.request, let image = convertImageData(imageData) {
            imageCache.add(image, for: request)
        }

        onSuccess?(imageData)
    }

    func parseResponse(response: DataResponse<Data>, onSuccess: ((JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {

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

    func parseSuccessResponse(_ response: JSONDictionary, onSuccess: ((JSONDictionary) -> Void)?) {
        onSuccess?(response)
    }

    func parseErrorResponse(error: String?, onError: HttpErrorClosure?) {
        onError?(error ?? WeatherClient.unknownErrorMessage)
    }
}
