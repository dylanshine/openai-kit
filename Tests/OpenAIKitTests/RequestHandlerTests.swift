import XCTest
import NIOHTTP1
import NIOPosix
import AsyncHTTPClient
@testable import OpenAIKit

final class RequestHandlerTests: XCTestCase {
    
    private var httpClient: HTTPClient!
    
    override func setUp() {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
    }
    
    override func tearDownWithError() throws {
        try httpClient.syncShutdown()
    }
    
    private func requestHandler(
        configuration: Configuration
    ) -> RequestHandler {
        return RequestHandler(httpClient: httpClient, configuration: configuration)
    }
    
    func test_generateURL_requestWithCustomValues() throws {
        let configuration = Configuration(apiKey: "TEST")
        
        let request = TestRequest(
            scheme: .custom("openai"),
            host: "chatgpt.is.cool",
            path: "/v1/i-know"
        )
        
        let url = try requestHandler(configuration: configuration).generateURL(for: request)
        
        XCTAssertEqual(url, "openai://chatgpt.is.cool/v1/i-know")
    }
    
    func test_generateURL_configWithCustomValues() throws {
        let api = API(scheme: .http, host: "chat.openai.com")
        let configuration = Configuration(apiKey: "TEST", api: api)
        
        let request = TestRequest(
            scheme: .https,
            host: "some-host",
            path: "/v1/test"
        )
        
        let url = try requestHandler(configuration: configuration).generateURL(for: request)
        
        XCTAssertEqual(url, "http://chat.openai.com/v1/test")
    }
    
}

private struct TestRequest: Request {
    let method: HTTPMethod = .GET
    let scheme: API.Scheme
    let host: String
    let path: String
}
