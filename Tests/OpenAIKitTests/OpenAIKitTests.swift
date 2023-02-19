import XCTest
import AsyncHTTPClient
@testable import OpenAIKit

final class OpenAIKitTests: XCTestCase {
    
    private var httpClient: HTTPClient!
    private var client: Client!
    
    override func setUp() {
        httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
        
        let configuration = Configuration(apiKey: "YOUR-API-KEY")
        
        client = Client(
            httpClient: httpClient,
            configuration: configuration
        )
    }
    
    override func tearDown() async throws {
        try await httpClient.shutdown()
    }
    
    func test_error() async throws {
        do {
            _ = try await client.files.retrieve(id: "NOT-VALID-ID")
        } catch {
            print(error)
        }
        
    }
    
    func test_listModels() async throws {
        let models = try await client.models.list()
        print(models)
        for model in models {
            print("\(model)\n")
        }
    }
    
    func test_retrieveModel() async throws {
        let davinciModel = try await client.models.retrieve(id: Model.GPT3.davinci.id)
        print("davinciModel: \(davinciModel)")
    }
    
    func test_createCompletion() async throws {
        let completion = try await client.completions.create(
            model: Model.GPT3.davinci,
            prompts: ["Write a haiku"]
        )
        print(completion)
    }
    
    func test_createEdit() async throws {
        let edit = try await client.edits.create(
            input: "Whay day of the wek is it?",
            instruction: "Fix the spelling mistakes"
        )
        print(edit)
    }
    
    func test_createImage() async throws {
        let image = try await client.images.create(prompt: "Golf player Tiger Woods eating soup")
        print(image)
    }
    
    func test_createEditImage() async throws {
        let url = Bundle.module.url(forResource: "logo", withExtension: "png")!
        print(url)
        let data = try Data(contentsOf: url)
        let image = try await client.images.createEdit(
            image: data,
            mask: data,
            prompt: "Change background color to blue"
        )
        print(image)
    }
    
    func test_createImageVariation() async throws {
        let url = Bundle.module.url(forResource: "logo", withExtension: "png")!
        let data = try Data(contentsOf: url)
        let image = try await client.images.createVariation(image: data)
        print(image)
    }
    
    func test_createEmbedding() async throws {
        let embedding = try await client.embeddings.create(input: "he food was delicious and the waiter...")
        print(embedding)
    }
    
    func test_listFiles() async throws {
        let files = try await client.files.list()
        print(files)
    }
    
    func test_uploadFile() async throws {
        let url = Bundle.module.url(forResource: "example", withExtension: "jsonl")!
        print(url)
        let data = try Data(contentsOf: url)
        let file = try await client.files.upload(
            file: data,
            fileName: "test.jsonl",
            purpose: .answers
        )
        print(file)
    }
    
    func test_deleteFile() async throws {
        let response = try await client.files.delete(id: "FILE-ID")
        print(response)
    }
    
    func test_retrieveFile() async throws {
        let file = try await client.files.retrieve(id: "FILE-ID")
        print(file)
    }
    
    func test_retrieveFileContent() async throws {
        let file = try await client.files.retrieveFileContent(id: "FILE-ID")
        print(file)
    }
    
    func test_createModeration() async throws {
        var moderation = try await client.moderations.createModeration(input: "I want to kill them.")
        print(moderation)
        moderation = try await client.moderations.createModeration(input: "I will jump from the bridge.")
        print(moderation)
        moderation = try await client.moderations.createModeration(input: "blond girls are dumb.")
        print(moderation)
    }
    
}
