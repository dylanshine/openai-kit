import AsyncHTTPClient
import NIO
import NIOHTTP1
import Foundation

public final class Client {
    
    public let audio: AudioProvider
    public let chats: ChatProvider
    public let completions: CompletionProvider
    public let edits: EditProvider
    public let embeddings: EmbeddingProvider
    public let files: FileProvider
    public let images: ImageProvider
    public let models: ModelProvider
    public let moderations: ModerationProvider
    
    // Hold onto reference of internally created HTTPClient to perform appropriate shutdowns.
    private let _httpClient: HTTPClient?

    public init(
        // If an HTTPClient is not provided, an internal one will be created, and will be shutdown after the lifecycle of the Client
        httpClient: HTTPClient? = nil,
        configuration: Configuration
    ) {
        
        // If an httpClient is provided, don't hold reference to it.
        self._httpClient = httpClient == nil ? HTTPClient(eventLoopGroupProvider: .createNew) : nil
        
        let requestHandler = RequestHandler(
            httpClient: httpClient ?? _httpClient!,
            configuration: configuration
        )
        
        self.audio = AudioProvider(requestHandler: requestHandler)
        self.models = ModelProvider(requestHandler: requestHandler)
        self.completions = CompletionProvider(requestHandler: requestHandler)
        self.chats = ChatProvider(requestHandler: requestHandler)
        self.edits = EditProvider(requestHandler: requestHandler)
        self.images = ImageProvider(requestHandler: requestHandler)
        self.embeddings = EmbeddingProvider(requestHandler: requestHandler)
        self.files = FileProvider(requestHandler: requestHandler)
        self.moderations = ModerationProvider(requestHandler: requestHandler)
        
    }
    
    deinit {
        /**
         syncShutdown() must not be called when on an EventLoop.
         Calling syncShutdown() on any EventLoop can lead to deadlocks.
         */
        guard MultiThreadedEventLoopGroup.currentEventLoop == nil else { return }
        
        try? _httpClient?.syncShutdown()
    }

}
