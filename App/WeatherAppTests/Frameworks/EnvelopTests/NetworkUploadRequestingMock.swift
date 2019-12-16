//
//  NetworkUploadRequestingMock.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Alamofire
import EnvelopeNetwork

public class NetworkUploadRequestingMock<T: DataResponseSerializerProtocol>: NetworkRequestingMock<T>, NetworkUploadRequesting {

    // MARK: - NetworkUploadRequesting
    @discardableResult
    public func uploadProgress(
        queue: DispatchQueue,
        closure: @escaping Request.ProgressHandler)
        -> Self {

            uploadProgressCallCount += 1
            self.uploadProgressHandler?(queue, closure)
            return self
    }
    public var uploadProgressCallCount: Int = 0
    public var uploadProgressHandler: ((_ queue: DispatchQueue, _ closure: @escaping Request.ProgressHandler) -> ())? = nil
}
