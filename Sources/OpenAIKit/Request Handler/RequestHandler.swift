import AsyncHTTPClient
import NIO
import NIOHTTP1
import NIOFoundationCompat
import Foundation

struct RequestHandler {
    
    let httpClient: HTTPClient
    let configuration: Configuration
    let decoder: JSONDecoder
    
    init(
        httpClient: HTTPClient,
        configuration: Configuration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.decoder = decoder
    }
    
    func generateURL(for request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
            
        guard let url = components.url else {
            throw RequestHandlerError.invalidURLGenerated
        }
    
        return url.absoluteString
    }
    
    func perform<T: Decodable>(request: Request) async throws -> T {
        var headers = configuration.headers
        
        headers.add(contentsOf: request.headers)
        
        let url = try generateURL(for: request)
        
        let response = try await httpClient.execute(
            request: HTTPClient.Request(
                url: url,
                method: request.method,
                headers: headers,
                body: request.body
            )
        ).get()
        
        
        guard let byteBuffer = response.body else {
            throw RequestHandlerError.responseBodyMissing
        }
        
        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        decoder.dateDecodingStrategy = request.dateDecodingStrategy

        do {
            return try decoder.decode(T.self, from: byteBuffer)
        } catch {
            print(error)
            throw try decoder.decode(APIErrorResponse.self, from: byteBuffer)
        }
                    
    }
}
