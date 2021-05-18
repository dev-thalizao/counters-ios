import XCTest
import HTTPClient
import CounterTests
@testable import URLSessionHTTPClient

final class URLSessionHTTPClientTests: XCTestCase {

    func testURLSessionGetFromAValidEndpoint() {
        let url = URL(string: "https://httpbin.org/get?a=b")!

        expect(makeSUT(), load: .init(url: url)) { (result) in
            switch result {
            case let .success((data, response)):
                let json = try? JSONDecoder().decode(HttpBinRoot.self, from: data)
                
                XCTAssertEqual(json?.args?.a, "b")
                XCTAssertEqual(response.statusCode, 200)
            case let .failure(error):
                XCTFail("URLSession get broken - \(error)")
            }
        }
    }
    
    func testURLSessionPostFromAValidEndpoint() throws {
        var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["c": "d"], options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        expect(makeSUT(), load: request) { (result) in
            switch result {
            case let .success((data, response)):
                let json = try? JSONDecoder().decode(HttpBinRoot.self, from: data)
                
                XCTAssertEqual(json?.json?.c, "d")
                XCTAssertEqual(response.statusCode, 200)
            case let .failure(error):
                XCTFail("URLSession get broken - \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func expect(
        _ client: URLSessionHTTPClient,
        load request: URLRequest,
        thenAssert: @escaping (HTTPClient.Result) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for request")
        
        client.execute(request) { (result) in
            thenAssert(result)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }
}

private struct HttpBinRoot: Codable {
    let args: HttpBinArgs?
    let json: HttpBinJson?
}

private struct HttpBinArgs: Codable {
    let a: String?
}

private struct HttpBinJson: Codable {
    let c: String?
}
