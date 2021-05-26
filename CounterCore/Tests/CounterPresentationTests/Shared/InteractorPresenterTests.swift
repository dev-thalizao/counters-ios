//
//  InteractorPresenterTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterTests
@testable import CounterPresentation

final class InteractorPresenterTests: XCTestCase {
    
    func testInitDoesNotTriggerAnyCall() {
        let (_, view) = makeSUT()
        XCTAssertEqual(view.messages, [])
    }
    
    func testDidStartLoadingDisplayNoErrorAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .loading(isLoading: true),
            .error(reason: nil)
        ])
    }
    
    func testDidFinishLoadingDisplayResourceAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { (resource) in
            return resource.appending("ViewModel")
        })
        
        sut.didFinishLoading(with: "Resource")
        
        XCTAssertEqual(view.messages, [
            .loading(isLoading: false),
            .success(resource: "ResourceViewModel")
        ])
    }
    
    func testDidFinishLoadingDisplayErrorAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .loading(isLoading: false),
            .error(reason: anyNSError().localizedDescription)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        mapper: @escaping TestPresenter.Mapper = { $0 },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: TestPresenter, view: InteractorResourceViewSpy) {
        let view = InteractorResourceViewSpy()
        let sut = TestPresenter(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
}
