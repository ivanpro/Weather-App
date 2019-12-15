// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
import AVFoundation
import MapKit
#elseif os(OSX)
import AppKit
#endif













class AppCoordinatorMock: AppCoordinatorInterface {

//MARK: - start

var startCallsCount = 0
var startCalled: Bool {
return startCallsCount > 0
}
var startClosure: (() -> Void)?

func start() {
startCallsCount += 1
startClosure?()
}

}
class CurrentUserLocationUseCaseDelegateMock: CurrentUserLocationUseCaseDelegate {

//MARK: - weatherForUserLocation

var weatherForUserLocationCallsCount = 0
var weatherForUserLocationCalled: Bool {
return weatherForUserLocationCallsCount > 0
}
var weatherForUserLocationReceivedWeather: Weather?
var weatherForUserLocationClosure: ((Weather) -> Void)?

func weatherForUserLocation(_ weather: Weather) {
weatherForUserLocationCallsCount += 1
weatherForUserLocationReceivedWeather = weather
weatherForUserLocationClosure?(weather)
}

//MARK: - failedToAcquireUserLocation

var failedToAcquireUserLocationErrorMessageCallsCount = 0
var failedToAcquireUserLocationErrorMessageCalled: Bool {
return failedToAcquireUserLocationErrorMessageCallsCount > 0
}
var failedToAcquireUserLocationErrorMessageReceivedErrorMessage: String?
var failedToAcquireUserLocationErrorMessageClosure: ((String) -> Void)?

func failedToAcquireUserLocation(errorMessage: String) {
failedToAcquireUserLocationErrorMessageCallsCount += 1
failedToAcquireUserLocationErrorMessageReceivedErrorMessage = errorMessage
failedToAcquireUserLocationErrorMessageClosure?(errorMessage)
}

}
class CurrentUserLocationUseCaseMock: CurrentUserLocationUseCaseInterface {
var delegate: CurrentUserLocationUseCaseDelegate?

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReturnValue: (() -> Void)?!
var executeClosure: (() -> (() -> Void)?)?

func execute() -> (() -> Void)? {
executeCallsCount += 1
return executeClosure.map({ $0() }) ?? executeReturnValue
}

}
class FetchLastLocationWeatherUseCaseDelegateMock: FetchLastLocationWeatherUseCaseDelegate {

//MARK: - successWeatherResponseForLocation

var successWeatherResponseForLocationWeatherCallsCount = 0
var successWeatherResponseForLocationWeatherCalled: Bool {
return successWeatherResponseForLocationWeatherCallsCount > 0
}
var successWeatherResponseForLocationWeatherReceivedWeather: Weather?
var successWeatherResponseForLocationWeatherClosure: ((Weather) -> Void)?

func successWeatherResponseForLocation(weather: Weather) {
successWeatherResponseForLocationWeatherCallsCount += 1
successWeatherResponseForLocationWeatherReceivedWeather = weather
successWeatherResponseForLocationWeatherClosure?(weather)
}

//MARK: - failedWeatherResponseForLocation

var failedWeatherResponseForLocationErrorMessageCallsCount = 0
var failedWeatherResponseForLocationErrorMessageCalled: Bool {
return failedWeatherResponseForLocationErrorMessageCallsCount > 0
}
var failedWeatherResponseForLocationErrorMessageReceivedErrorMessage: String?
var failedWeatherResponseForLocationErrorMessageClosure: ((String) -> Void)?

func failedWeatherResponseForLocation(errorMessage: String) {
failedWeatherResponseForLocationErrorMessageCallsCount += 1
failedWeatherResponseForLocationErrorMessageReceivedErrorMessage = errorMessage
failedWeatherResponseForLocationErrorMessageClosure?(errorMessage)
}

}
class FetchLastLocationWeatherUseCaseMock: FetchLastLocationWeatherUseCaseInterface {
var delegate: FetchLastLocationWeatherUseCaseDelegate?

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReturnValue: Bool!
var executeClosure: (() -> Bool)?

func execute() -> Bool {
executeCallsCount += 1
return executeClosure.map({ $0() }) ?? executeReturnValue
}

}
class FetchWeatherForCoordinateUseCaseDelegateMock: FetchWeatherForCoordinateUseCaseDelegate {

//MARK: - successWeatherResponseForLocation

var successWeatherResponseForLocationCallsCount = 0
var successWeatherResponseForLocationCalled: Bool {
return successWeatherResponseForLocationCallsCount > 0
}
var successWeatherResponseForLocationReceivedWeather: Weather?
var successWeatherResponseForLocationClosure: ((Weather) -> Void)?

func successWeatherResponseForLocation(_ weather: Weather) {
successWeatherResponseForLocationCallsCount += 1
successWeatherResponseForLocationReceivedWeather = weather
successWeatherResponseForLocationClosure?(weather)
}

//MARK: - failedWeatherResponseForLocation

var failedWeatherResponseForLocationCallsCount = 0
var failedWeatherResponseForLocationCalled: Bool {
return failedWeatherResponseForLocationCallsCount > 0
}
var failedWeatherResponseForLocationReceivedErrorMessage: String?
var failedWeatherResponseForLocationClosure: ((String) -> Void)?

func failedWeatherResponseForLocation(_ errorMessage: String) {
failedWeatherResponseForLocationCallsCount += 1
failedWeatherResponseForLocationReceivedErrorMessage = errorMessage
failedWeatherResponseForLocationClosure?(errorMessage)
}

}
class FetchWeatherForCoordinateUseCaseMock: FetchWeatherForCoordinateUseCaseInterface {
var delegate: FetchWeatherForCoordinateUseCaseDelegate?

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReceivedInput: Coordinate?
var executeClosure: ((Coordinate) -> Void)?

func execute(_ input: Coordinate) {
executeCallsCount += 1
executeReceivedInput = input
executeClosure?(input)
}

}
class FetchWeatherForLocationUseCaseMock: FetchWeatherForLocationUseCaseInterface {
var delegate: FetchWeatherForLocationUseCaseDelegate?

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReceivedInput: String?
var executeClosure: ((String) -> Void)?

func execute(_ input: String) {
executeCallsCount += 1
executeReceivedInput = input
executeClosure?(input)
}

}
class FetchWeatherRepositoryDelegateMock: FetchWeatherRepositoryDelegate {

//MARK: - fetchWeatherForLocationSuccess

var fetchWeatherForLocationSuccessWeatherCallsCount = 0
var fetchWeatherForLocationSuccessWeatherCalled: Bool {
return fetchWeatherForLocationSuccessWeatherCallsCount > 0
}
var fetchWeatherForLocationSuccessWeatherReceivedWeather: Weather?
var fetchWeatherForLocationSuccessWeatherClosure: ((Weather) -> Void)?

func fetchWeatherForLocationSuccess(weather: Weather) {
fetchWeatherForLocationSuccessWeatherCallsCount += 1
fetchWeatherForLocationSuccessWeatherReceivedWeather = weather
fetchWeatherForLocationSuccessWeatherClosure?(weather)
}

//MARK: - fetchWeatherForLocationError

var fetchWeatherForLocationErrorErrorMessageCallsCount = 0
var fetchWeatherForLocationErrorErrorMessageCalled: Bool {
return fetchWeatherForLocationErrorErrorMessageCallsCount > 0
}
var fetchWeatherForLocationErrorErrorMessageReceivedErrorMessage: String?
var fetchWeatherForLocationErrorErrorMessageClosure: ((String) -> Void)?

func fetchWeatherForLocationError(errorMessage: String) {
fetchWeatherForLocationErrorErrorMessageCallsCount += 1
fetchWeatherForLocationErrorErrorMessageReceivedErrorMessage = errorMessage
fetchWeatherForLocationErrorErrorMessageClosure?(errorMessage)
}

}
class GetWeatherIconForLocationUseCaseMock: GetWeatherIconForLocationUseCaseInterface {
var delegate: GetWeatherIconForLocationUseCaseDelegate?

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReceivedInput: String?
var executeClosure: ((String) -> Void)?

func execute(_ input: String) {
executeCallsCount += 1
executeReceivedInput = input
executeClosure?(input)
}

}
class LocationMock: LocationInterface {

//MARK: - getUserLocation

var getUserLocationOnCompletionCallsCount = 0
var getUserLocationOnCompletionCalled: Bool {
return getUserLocationOnCompletionCallsCount > 0
}
var getUserLocationOnCompletionReceivedOnCompletion: ((UserLocationResult) -> Void)?
var getUserLocationOnCompletionReturnValue: CancelHandler?!
var getUserLocationOnCompletionClosure: ((@escaping (UserLocationResult) -> Void) -> CancelHandler?)?

func getUserLocation(onCompletion: @escaping (UserLocationResult) -> Void) -> CancelHandler? {
getUserLocationOnCompletionCallsCount += 1
getUserLocationOnCompletionReceivedOnCompletion = onCompletion
return getUserLocationOnCompletionClosure.map({ $0(onCompletion) }) ?? getUserLocationOnCompletionReturnValue
}

}
class PersistenceMock: PersistenceInterface {

//MARK: - addItem

var addItemCallsCount = 0
var addItemCalled: Bool {
return addItemCallsCount > 0
}
var addItemReceivedValue: String?
var addItemClosure: ((String) -> Void)?

func addItem(_ value: String) {
addItemCallsCount += 1
addItemReceivedValue = value
addItemClosure?(value)
}

//MARK: - lastStoredItem

var lastStoredItemCallsCount = 0
var lastStoredItemCalled: Bool {
return lastStoredItemCallsCount > 0
}
var lastStoredItemReturnValue: String?!
var lastStoredItemClosure: (() -> String?)?

func lastStoredItem() -> String? {
lastStoredItemCallsCount += 1
return lastStoredItemClosure.map({ $0() }) ?? lastStoredItemReturnValue
}

//MARK: - removeItem

var removeItemCallsCount = 0
var removeItemCalled: Bool {
return removeItemCallsCount > 0
}
var removeItemReceivedValue: String?
var removeItemClosure: ((String) -> Void)?

func removeItem(_ value: String) {
removeItemCallsCount += 1
removeItemReceivedValue = value
removeItemClosure?(value)
}

//MARK: - allItems

var allItemsCallsCount = 0
var allItemsCalled: Bool {
return allItemsCallsCount > 0
}
var allItemsReturnValue: [String]!
var allItemsClosure: (() -> [String])?

func allItems() -> [String] {
allItemsCallsCount += 1
return allItemsClosure.map({ $0() }) ?? allItemsReturnValue
}

}
class RemoveStoredLocationUseCaseMock: RemoveStoredLocationUseCaseInterface {

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReceivedInput: String?
var executeClosure: ((String) -> Void)?

func execute(_ input: String) {
executeCallsCount += 1
executeReceivedInput = input
executeClosure?(input)
}

}
class RetrieveLastSearchedLocationUseCaseMock: RetrieveLastSearchedLocationUseCaseInterface {

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReturnValue: String?!
var executeClosure: (() -> String?)?

func execute() -> String? {
executeCallsCount += 1
return executeClosure.map({ $0() }) ?? executeReturnValue
}

}
class RetrieveSearchedLocationsUseCaseMock: RetrieveSearchedLocationsUseCaseInterface {

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReturnValue: [String]!
var executeClosure: (() -> [String])?

func execute() -> [String] {
executeCallsCount += 1
return executeClosure.map({ $0() }) ?? executeReturnValue
}

}
class SearchCoordinatorMock: SearchCoordinatorInterface {

//MARK: - start

var startCallsCount = 0
var startCalled: Bool {
return startCallsCount > 0
}
var startClosure: (() -> Void)?

func start() {
startCallsCount += 1
startClosure?()
}

}
class SearchViewModelDataSourceMock: SearchViewModelDataSourceInterface {

//MARK: - didSelectLocation

var didSelectLocationCallsCount = 0
var didSelectLocationCalled: Bool {
return didSelectLocationCallsCount > 0
}
var didSelectLocationReceivedLocation: String?
var didSelectLocationClosure: ((String) -> Void)?

func didSelectLocation(_ location: String) {
didSelectLocationCallsCount += 1
didSelectLocationReceivedLocation = location
didSelectLocationClosure?(location)
}

//MARK: - didRemoveLocation

var didRemoveLocationCallsCount = 0
var didRemoveLocationCalled: Bool {
return didRemoveLocationCallsCount > 0
}
var didRemoveLocationReceivedLocation: String?
var didRemoveLocationClosure: ((String) -> Void)?

func didRemoveLocation(_ location: String) {
didRemoveLocationCallsCount += 1
didRemoveLocationReceivedLocation = location
didRemoveLocationClosure?(location)
}

}
class SearchViewModelMock: SearchViewModelInterface {
var coordinatorDelegate: SearchCoordinatorDelegate?
var dataSourceDelegate: SearchViewModelDataSourceDelegate?

//MARK: - viewDidLoad

var viewDidLoadCallsCount = 0
var viewDidLoadCalled: Bool {
return viewDidLoadCallsCount > 0
}
var viewDidLoadClosure: (() -> Void)?

func viewDidLoad() {
viewDidLoadCallsCount += 1
viewDidLoadClosure?()
}

//MARK: - textFieldShouldReturn

var textFieldShouldReturnCallsCount = 0
var textFieldShouldReturnCalled: Bool {
return textFieldShouldReturnCallsCount > 0
}
var textFieldShouldReturnReceivedText: String?
var textFieldShouldReturnReturnValue: Bool!
var textFieldShouldReturnClosure: ((String?) -> Bool)?

func textFieldShouldReturn(_ text: String?) -> Bool {
textFieldShouldReturnCallsCount += 1
textFieldShouldReturnReceivedText = text
return textFieldShouldReturnClosure.map({ $0(text) }) ?? textFieldShouldReturnReturnValue
}

//MARK: - didSelectLocation

var didSelectLocationCallsCount = 0
var didSelectLocationCalled: Bool {
return didSelectLocationCallsCount > 0
}
var didSelectLocationReceivedLocation: String?
var didSelectLocationClosure: ((String) -> Void)?

func didSelectLocation(_ location: String) {
didSelectLocationCallsCount += 1
didSelectLocationReceivedLocation = location
didSelectLocationClosure?(location)
}

//MARK: - didRemoveLocation

var didRemoveLocationCallsCount = 0
var didRemoveLocationCalled: Bool {
return didRemoveLocationCallsCount > 0
}
var didRemoveLocationReceivedLocation: String?
var didRemoveLocationClosure: ((String) -> Void)?

func didRemoveLocation(_ location: String) {
didRemoveLocationCallsCount += 1
didRemoveLocationReceivedLocation = location
didRemoveLocationClosure?(location)
}

}
class StoreSearchedLocationUseCaseMock: StoreSearchedLocationUseCaseInterface {

//MARK: - execute

var executeCallsCount = 0
var executeCalled: Bool {
return executeCallsCount > 0
}
var executeReceivedInput: String?
var executeClosure: ((String) -> Void)?

func execute(_ input: String) {
executeCallsCount += 1
executeReceivedInput = input
executeClosure?(input)
}

}
class UserDefaultsMock: UserDefaultsInterface {

//MARK: - set

var setForKeyCallsCount = 0
var setForKeyCalled: Bool {
return setForKeyCallsCount > 0
}
var setForKeyReceivedArguments: (value: Any?, defaultName: String)?
var setForKeyClosure: ((Any?, String) -> Void)?

func set(_ value: Any?, forKey defaultName: String) {
setForKeyCallsCount += 1
setForKeyReceivedArguments = (value: value, defaultName: defaultName)
setForKeyClosure?(value, defaultName)
}

//MARK: - array

var arrayForKeyCallsCount = 0
var arrayForKeyCalled: Bool {
return arrayForKeyCallsCount > 0
}
var arrayForKeyReceivedDefaultName: String?
var arrayForKeyReturnValue: [Any]?!
var arrayForKeyClosure: ((String) -> [Any]?)?

func array(forKey defaultName: String) -> [Any]? {
arrayForKeyCallsCount += 1
arrayForKeyReceivedDefaultName = defaultName
return arrayForKeyClosure.map({ $0(defaultName) }) ?? arrayForKeyReturnValue
}

}
class WeatherClientMock: WeatherClientInterface {

//MARK: - fetchWatherForLocation

var fetchWatherForLocationOnSuccessOnErrorCallsCount = 0
var fetchWatherForLocationOnSuccessOnErrorCalled: Bool {
return fetchWatherForLocationOnSuccessOnErrorCallsCount > 0
}
var fetchWatherForLocationOnSuccessOnErrorReceivedArguments: (location: String, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?)?
var fetchWatherForLocationOnSuccessOnErrorClosure: ((String, ((_ json: JSONDictionary) -> Void)?, HttpErrorClosure?) -> Void)?

func fetchWatherForLocation(_ location: String, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
fetchWatherForLocationOnSuccessOnErrorCallsCount += 1
fetchWatherForLocationOnSuccessOnErrorReceivedArguments = (location: location, onSuccess: onSuccess, onError: onError)
fetchWatherForLocationOnSuccessOnErrorClosure?(location, onSuccess, onError)
}

//MARK: - fetchWatherForCoordinates

var fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCallsCount = 0
var fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCalled: Bool {
return fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCallsCount > 0
}
var fetchWatherForCoordinatesLongitudeOnSuccessOnErrorReceivedArguments: (latitude: Double, longitude: Double, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?)?
var fetchWatherForCoordinatesLongitudeOnSuccessOnErrorClosure: ((Double, Double, ((_ json: JSONDictionary) -> Void)?, HttpErrorClosure?) -> Void)?

func fetchWatherForCoordinates(_ latitude: Double, longitude: Double, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?) {
fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCallsCount += 1
fetchWatherForCoordinatesLongitudeOnSuccessOnErrorReceivedArguments = (latitude: latitude, longitude: longitude, onSuccess: onSuccess, onError: onError)
fetchWatherForCoordinatesLongitudeOnSuccessOnErrorClosure?(latitude, longitude, onSuccess, onError)
}

//MARK: - fetchIconForWeather

var fetchIconForWeatherOnSuccessOnErrorCallsCount = 0
var fetchIconForWeatherOnSuccessOnErrorCalled: Bool {
return fetchIconForWeatherOnSuccessOnErrorCallsCount > 0
}
var fetchIconForWeatherOnSuccessOnErrorReceivedArguments: (iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?)?
var fetchIconForWeatherOnSuccessOnErrorClosure: ((String, ((Data) -> Void)?, HttpErrorClosure?) -> Void)?

func fetchIconForWeather(_ iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?) {
fetchIconForWeatherOnSuccessOnErrorCallsCount += 1
fetchIconForWeatherOnSuccessOnErrorReceivedArguments = (iconId: iconId, onSuccess: onSuccess, onError: onError)
fetchIconForWeatherOnSuccessOnErrorClosure?(iconId, onSuccess, onError)
}

}
class WeatherCoordinatorMock: WeatherCoordinatorInterface {

//MARK: - start

var startCallsCount = 0
var startCalled: Bool {
return startCallsCount > 0
}
var startClosure: (() -> Void)?

func start() {
startCallsCount += 1
startClosure?()
}

}
class WeatherIconRepositoryDelegateMock: WeatherIconRepositoryDelegate {

//MARK: - fetchWeatherForLocationSuccess

var fetchWeatherForLocationSuccessCallsCount = 0
var fetchWeatherForLocationSuccessCalled: Bool {
return fetchWeatherForLocationSuccessCallsCount > 0
}
var fetchWeatherForLocationSuccessReceivedImage: Data?
var fetchWeatherForLocationSuccessClosure: ((Data) -> Void)?

func fetchWeatherForLocationSuccess(_ image: Data) {
fetchWeatherForLocationSuccessCallsCount += 1
fetchWeatherForLocationSuccessReceivedImage = image
fetchWeatherForLocationSuccessClosure?(image)
}

//MARK: - fetchWeatherIconError

var fetchWeatherIconErrorCallsCount = 0
var fetchWeatherIconErrorCalled: Bool {
return fetchWeatherIconErrorCallsCount > 0
}
var fetchWeatherIconErrorReceivedErrorMessage: String?
var fetchWeatherIconErrorClosure: ((String) -> Void)?

func fetchWeatherIconError(_ errorMessage: String) {
fetchWeatherIconErrorCallsCount += 1
fetchWeatherIconErrorReceivedErrorMessage = errorMessage
fetchWeatherIconErrorClosure?(errorMessage)
}

}
class WeatherRepositoryMock: WeatherRepositoryInterface {
var fetchDelegate: FetchWeatherRepositoryDelegate?
var iconDelegate: WeatherIconRepositoryDelegate?

//MARK: - fetchWeatherForLocation

var fetchWeatherForLocationCallsCount = 0
var fetchWeatherForLocationCalled: Bool {
return fetchWeatherForLocationCallsCount > 0
}
var fetchWeatherForLocationReceivedLocation: String?
var fetchWeatherForLocationClosure: ((String) -> Void)?

func fetchWeatherForLocation(_ location: String) {
fetchWeatherForLocationCallsCount += 1
fetchWeatherForLocationReceivedLocation = location
fetchWeatherForLocationClosure?(location)
}

//MARK: - fetchWeatherForCoordinate

var fetchWeatherForCoordinateCallsCount = 0
var fetchWeatherForCoordinateCalled: Bool {
return fetchWeatherForCoordinateCallsCount > 0
}
var fetchWeatherForCoordinateReceivedCoordinate: Coordinate?
var fetchWeatherForCoordinateClosure: ((Coordinate) -> Void)?

func fetchWeatherForCoordinate(_ coordinate: Coordinate) {
fetchWeatherForCoordinateCallsCount += 1
fetchWeatherForCoordinateReceivedCoordinate = coordinate
fetchWeatherForCoordinateClosure?(coordinate)
}

//MARK: - fetchIconForWeather

var fetchIconForWeatherCallsCount = 0
var fetchIconForWeatherCalled: Bool {
return fetchIconForWeatherCallsCount > 0
}
var fetchIconForWeatherReceivedIconName: String?
var fetchIconForWeatherClosure: ((String) -> Void)?

func fetchIconForWeather(_ iconName: String) {
fetchIconForWeatherCallsCount += 1
fetchIconForWeatherReceivedIconName = iconName
fetchIconForWeatherClosure?(iconName)
}

}
class WeatherViewModelMock: WeatherViewModelInterface {
var delegate: WeatherViewModelDelegate?
var coordinatorDelegate: WeatherCoordinatorDelegate?

//MARK: - viewDidLoad

var viewDidLoadCallsCount = 0
var viewDidLoadCalled: Bool {
return viewDidLoadCallsCount > 0
}
var viewDidLoadClosure: (() -> Void)?

func viewDidLoad() {
viewDidLoadCallsCount += 1
viewDidLoadClosure?()
}

//MARK: - viewDidDisappear

var viewDidDisappearCallsCount = 0
var viewDidDisappearCalled: Bool {
return viewDidDisappearCallsCount > 0
}
var viewDidDisappearClosure: (() -> Void)?

func viewDidDisappear() {
viewDidDisappearCallsCount += 1
viewDidDisappearClosure?()
}

//MARK: - tryAgainPressed

var tryAgainPressedCallsCount = 0
var tryAgainPressedCalled: Bool {
return tryAgainPressedCallsCount > 0
}
var tryAgainPressedClosure: (() -> Void)?

func tryAgainPressed() {
tryAgainPressedCallsCount += 1
tryAgainPressedClosure?()
}

//MARK: - searchPressed

var searchPressedCallsCount = 0
var searchPressedCalled: Bool {
return searchPressedCallsCount > 0
}
var searchPressedClosure: (() -> Void)?

func searchPressed() {
searchPressedCallsCount += 1
searchPressedClosure?()
}

//MARK: - gpsPressed

var gpsPressedCallsCount = 0
var gpsPressedCalled: Bool {
return gpsPressedCallsCount > 0
}
var gpsPressedClosure: (() -> Void)?

func gpsPressed() {
gpsPressedCallsCount += 1
gpsPressedClosure?()
}

//MARK: - loadWeather

var loadWeatherCallsCount = 0
var loadWeatherCalled: Bool {
return loadWeatherCallsCount > 0
}
var loadWeatherReceivedWeather: Weather?
var loadWeatherClosure: ((Weather) -> Void)?

func loadWeather(_ weather: Weather) {
loadWeatherCallsCount += 1
loadWeatherReceivedWeather = weather
loadWeatherClosure?(weather)
}

//MARK: - searchFailed

var searchFailedCallsCount = 0
var searchFailedCalled: Bool {
return searchFailedCallsCount > 0
}
var searchFailedReceivedErrorMessage: String?
var searchFailedClosure: ((String) -> Void)?

func searchFailed(_ errorMessage: String) {
searchFailedCallsCount += 1
searchFailedReceivedErrorMessage = errorMessage
searchFailedClosure?(errorMessage)
}

}
