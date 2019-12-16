//
//  WeatherClientTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
import EnvelopeNetwork
import Alamofire
@testable import WeatherApp

class WeatherClientTests: XCTestCase {
    func testFetchWeatherForLocationRequest() throws {
        let network = NetworkingMock()
        let mockUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=London&appid=95d190a434083879a6398aafd54d9e73&units=metric")!

        network.requestHandler = { (url: URLConvertible,
            method: HTTPMethod,
            parameters: Parameters?,
            encoding: ParameterEncoding,
            headers: HTTPHeaders?) -> NetworkRequesting in

            XCTAssertEqual(try? url.asURL().absoluteString, mockUrl.absoluteString)
            XCTAssertEqual(method, .get)

            return NetworkRequestingMock<DataResponseSerializer<Data>>()
        }

        let client = WeatherClient(network: network)
        client.fetchWatherForLocation("London", onSuccess: nil, onError: nil)
    }

    func testFetchWeatherForCoordinateRequest() throws {
        let network = NetworkingMock()
        let mockUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=123.4560000000&lon=654.3210000000&appid=95d190a434083879a6398aafd54d9e73&units=metric")!

        network.requestHandler = { (url: URLConvertible,
            method: HTTPMethod,
            parameters: Parameters?,
            encoding: ParameterEncoding,
            headers: HTTPHeaders?) -> NetworkRequesting in

            XCTAssertEqual(try? url.asURL().absoluteString, mockUrl.absoluteString)
            XCTAssertEqual(method, .get)

            return NetworkRequestingMock<DataResponseSerializer<Data>>()
        }

        let client = WeatherClient(network: network)
        client.fetchWatherForCoordinates(123.456, longitude: 654.321, onSuccess: nil, onError: nil)
    }

    func testFetchIconForWeather() throws {
        let network = NetworkingMock()
        let mockUrl = URL(string: "https://openweathermap.org/img/wn/11d@2x.png")!

        network.requestHandler = { (url: URLConvertible,
            method: HTTPMethod,
            parameters: Parameters?,
            encoding: ParameterEncoding,
            headers: HTTPHeaders?) -> NetworkRequesting in

            XCTAssertEqual(try? url.asURL().absoluteString, mockUrl.absoluteString)
            XCTAssertEqual(method, .get)

            return NetworkRequestingMock<DataResponseSerializer<Data>>()
        }

        let client = WeatherClient(network: network)
        client.fetchIconForWeather("11d", onSuccess: nil, onError: nil)
    }

}
