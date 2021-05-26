//
//  XCTestCase+CounterTests.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import XCTest

public extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
