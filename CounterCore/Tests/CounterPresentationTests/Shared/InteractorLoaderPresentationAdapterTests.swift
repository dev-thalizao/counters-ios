//
//  InteractorLoaderPresentationAdapterTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterTests
@testable import CounterPresentation

final class InteractorLoaderPresentationAdapterTests: XCTestCase {
    
    func testInitDoesNotTriggerAnyCall() {
        let (_, view) = makeSUT()
        XCTAssertEqual(view.messages, [])
    }
    
    func testLoadPresentsResource() {
        let (sut, view) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(view.messages, [
            .loading(isLoading: true),
            .error(reason: nil),
            .loading(isLoading: false),
            .success(resource: "async resource")
        ])
    }
    
    func testLoadPresentsError() {
        let (sut, view) = makeSUT { $0(.failure(anyNSError())) }
        
        sut.load()
        
        XCTAssertEqual(view.messages, [
            .loading(isLoading: true),
            .error(reason: nil),
            .loading(isLoading: false),
            .error(reason: anyNSError().localizedDescription)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        loader: @escaping TestLoaderPresentationAdapter.Loader = { $0(.success("async resource")) },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: TestLoaderPresentationAdapter, view: InteractorResourceViewSpy) {
        let view = InteractorResourceViewSpy()
        let presenter = TestPresenter(resourceView: view, loadingView: view, errorView: view, mapper: { $0 })
        let sut = TestLoaderPresentationAdapter(loader: loader)
        sut.presenter = presenter
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func expect(
        _ view: InteractorResourceViewSpy,
        receives messages: [InteractorResourceViewSpy.Message],
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        XCTAssertEqual(view.messages, messages)
    }
}
