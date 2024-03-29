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
    let mockUrl = URL(string: "https://openweathermap.org/img/wn/11d@2x.png")!
    let error = NSError(domain: "Failed to parse image", code: 400, userInfo: nil)

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

    func testFetchImageFromCache() throws {
        let client = WeatherClient()
        client.imageCache.add(#imageLiteral(resourceName: "gps_icon.pdf"), withIdentifier: "11d")

        let imageData = try XCTUnwrap(client.fetchImageFromCache(for: "11d"))
        XCTAssertNotNil(imageData)
    }

    func testConvertDataToImage() throws {
        let client = WeatherClient()
        let imageData = try XCTUnwrap(#imageLiteral(resourceName: "gps_icon.pdf").pngData())
        let image = client.convertImageData(imageData)

        XCTAssertNotNil(image)
    }

    func testParseIconResponse() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Fixture.toData("sample_successful_request")
        let result = Result.success(data)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: data, result: result)

        client.parseIconResponse(dataResponse: dataResponse, onSuccess: { data in
            XCTAssertNotNil(data)
        }) { errorMessage in
            XCTFail("Should have parsed response successfully")
        }
    }

    func testFailParseIconResponse() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: self.mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: self.mockUrl, statusCode: 400, httpVersion: nil, headerFields: nil)
        let result = Result<Data>.failure(error)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: nil, result: result)

        client.parseIconResponse(dataResponse: dataResponse, onSuccess: { data in
            XCTFail("Response should have not been parsed")
        }) { errorMessage in
            XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (Failed to parse image error 400.)")
        }
    }

    func testParseWeatherResponse() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Fixture.toData("sample_successful_request")
        let result = Result.success(data)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: data, result: result)

        client.parseResponse(response: dataResponse, onSuccess: { json in
            let weather = Weather(with: json)
            XCTAssertEqual(weather?.location?.country, "GB")
            XCTAssertEqual(weather?.location?.city, "London")
        }) { errorMessage in
            XCTFail("Should have parsed response successfully")
        }
    }

    func testParseWeatherResponse2() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: mockUrl, statusCode: 301, httpVersion: nil, headerFields: nil)
        let data = try JSONSerialization.data(withJSONObject: ["message": "Location not found"], options: .prettyPrinted)
        let result = Result.success(data)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: data, result: result)

        client.parseResponse(response: dataResponse, onSuccess: { json in
            XCTFail("Response should have not been parsed")
        }) { errorMessage in
            XCTAssertEqual(errorMessage, "Location not found")
        }
    }

    func testFailToParseJsonResponse() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data(base64Encoded: "")!
        let result = Result.success(data)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: data, result: result)

        client.parseResponse(response: dataResponse, onSuccess: { json in
            XCTFail("Response should have not been parsed")
        }) { errorMessage in
            XCTAssertEqual(errorMessage, "Failed to parse JSON object")
        }
    }

    func testParseWeatherResponseFail() throws {
        let client = WeatherClient()
        let urlRequest = try URLRequest(url: mockUrl, method: .get)
        let httpUrlResponse = HTTPURLResponse(url: mockUrl, statusCode: 401, httpVersion: nil, headerFields: nil)
        let data = Fixture.toData("sample_successful_request")
        let result = Result<Data>.failure(error)

        let dataResponse = DataResponse(request: urlRequest, response: httpUrlResponse, data: data, result: result)

        client.parseResponse(response: dataResponse, onSuccess: { json in
            XCTFail("Response should have not been parsed")
        }) { errorMessage in
            XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (Failed to parse image error 400.)")
        }
    }

}
