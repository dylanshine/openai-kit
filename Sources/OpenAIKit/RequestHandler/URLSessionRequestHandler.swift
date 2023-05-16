import Foundation

struct URLSessionRequestHandler: RequestHandler {
    let session: URLSession
    let configuration: Configuration
    let decoder: JSONDecoder
    
    init(
        session: URLSession,
        configuration: Configuration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
    }
    
    func perform<T>(request: Request) async throws -> T where T : Decodable {
        let urlRequest = try makeUrlRequest(request: request)
        let (data, _) = try await session.data(for: urlRequest)
        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        decoder.dateDecodingStrategy = request.dateDecodingStrategy
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw try decoder.decode(APIErrorResponse.self, from: data)
        }
    }
    
    func stream<T>(request: Request) async throws -> AsyncThrowingStream<T, Error> where T : Decodable {
        var urlRequest = try makeUrlRequest(request: request)
        urlRequest.timeoutInterval = 25
        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        decoder.dateDecodingStrategy = request.dateDecodingStrategy
        
        return AsyncThrowingStream<T, Error> { [urlRequest] continuation in
            Task(priority: .userInitiated) {
                do {
                    let (data, _) = try await session.data(for: urlRequest)
                    let value = try decoder.decode(T.self, from: data)
                    continuation.yield(value)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private func makeUrlRequest(request: Request) throws -> URLRequest {
        let urlString = try generateURL(for: request)
        guard let url = URL(string: urlString) else {
            throw RequestHandlerError.invalidURLGenerated
        }
        var urlRequest = URLRequest(url: url)
        for (key, value) in configuration.headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        for (key, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return urlRequest
    }
}
