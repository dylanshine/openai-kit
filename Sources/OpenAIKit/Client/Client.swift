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
    
    private let httpClient: HTTPClient

    public init(
        httpClient: HTTPClient = HTTPClient(eventLoopGroupProvider: .createNew),
        configuration: Configuration
    ) {
        
        self.httpClient = httpClient

        let requestHandler = RequestHandler(
            httpClient: httpClient,
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
        try? httpClient.syncShutdown()
    }

}
