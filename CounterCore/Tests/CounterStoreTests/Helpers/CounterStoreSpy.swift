//
//  CounterStoreSpy.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore
import CounterStore

final class CounterStoreSpy: CounterStore {

    enum Message: Equatable {
        case retrieve
        case insert
    }
    
    private(set) var messages = [Message]()
    private(set) var retrievalResult: Result<[Counter]?, Error>?
    private(set) var insertionResult: Result<Void, Error>?
    
    func retrieve() throws -> [Counter]? {
        messages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completionRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completionRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completionRetrieval(with counters: [Counter]) {
        retrievalResult = .success(counters)
    }
    
    func insert(_ counters: [Counter]) throws {
        messages.append(.insert)
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
}
