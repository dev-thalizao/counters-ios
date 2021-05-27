//
//  HTTPClientSpy.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterAPI

private class FakeTask: HTTPClientTask {
    func cancel() {}
}

final class HTTPClientSpy: HTTPClient {
    
    private(set) var requests = [URLRequest]()
    private(set) var stub: ((URLRequest) -> HTTPClient.Result)?
    
    func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requests.append(request)
        completion(stub!(request))
        return FakeTask()
    }
    
    func stubRequest(with error: Error) {
        stub = { _ in .failure(error) }
    }
    
    func stubRequest(with result: (Data, HTTPURLResponse)) {
        stub = { _ in .success(result) }
    }
    
    func stubRequest(with filter: @escaping (URLRequest) -> HTTPClient.Result) {
        stub = filter
    }
}
