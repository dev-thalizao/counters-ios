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
        case counter
        case delete
    }
    
    private(set) var messages = [Message]()
    private(set) var retrievalResult: Result<[Counter], Error>?
    private(set) var insertionResult: Result<Void, Error>?
    private(set) var counterResult: Result<Counter, Error>?
    private(set) var deletionResult: Result<Void, Error>?
    
    func retrieve() throws -> [Counter] {
        messages.append(.retrieve)
        return try retrievalResult!.get()
    }
    
    func completionRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completionRetrievalWithEmptyCache() {
        retrievalResult = .success([])
    }
    
    func completionRetrieval(with counters: [Counter]) {
        retrievalResult = .success(counters)
    }
    
    func insert(_ counters: [Counter]) throws {
        messages.append(.insert)
        try insertionResult!.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    func counter(with id: Counter.ID) throws -> Counter {
        messages.append(.counter)
        return try counterResult!.get()
    }
    
    func completeCounter(with error: Error) {
        counterResult = .failure(error)
    }
    
    func completeCounter(with counter: Counter) {
        counterResult = .success(counter)
    }
    
    func delete(with id: Counter.ID) throws {
        messages.append(.delete)
        try deletionResult!.get()
    }
    
    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
}
