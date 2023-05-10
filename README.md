# OpenAIKit

![Swift](http://img.shields.io/badge/swift-5.7-brightgreen.svg)

OpenAIKit is a Swift package used to communicate with the [OpenAI API](https://beta.openai.com/docs/api-reference/introduction).

## Setup
Add the dependency to Package.swift:

~~~~swift
dependencies: [
    ...
    .package(url: "https://github.com/dylanshine/openai-kit.git", from: "1.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "OpenAIKit", package: "openai-kit"),
    ]),
~~~~

It is encouraged to use environment variables to inject the OpenAI API key, instead of hardcoding it in the source code.

~~~~bash
# .env

OPENAI_API_KEY="YOUR-API-KEY"
OPENAI_ORGANIZATION="YOUR-ORGANIZATION"
~~~~
⚠️ OpenAI strongly recommends developers of client-side applications proxy requests through a separate backend service to keep their API key safe. API keys can access and manipulate customer billing, usage, and organizational data, so it's a significant risk to [expose](https://nshipster.com/secrets/) them.

Create a `OpenAIKit.Client` by passing a configuration.

~~~~swift
import AsyncHTTPClient
import NIO
import OpenAIKit

// Marked ObservableObject so the service can be used with the @EnvironmentObject property wrapper
final class OpenAiService: ObservableObject {
    let openAiClient: Client

    var apiKey: String {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"]!
    }

    var organization: String {
        ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"]!
    }

    init() {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        // Generally we would advise on creating a single HTTPClient for the lifecycle of your application and recommend shutting it down on application close.
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        let configuration = Configuration(apiKey: apiKey, organization: organization)
        openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }
}
~~~~


## Using the API

The OpenAIKit.Client implements a handful of methods to interact with the OpenAI API.

### Basic Chat

Here's an example of a simple function that prompts ChatGPT for a response to "Hi!" and returns ChatGPT's response as a String:

~~~~swift
import OpenAIKit

func getResponse() async throws -> String {
    let completion = try await openAiClient.completions.create(
        model: Model.GPT3.davinci,
        prompts: ["Hi!"]
    )

    // OpenAiError is a custom type created for this example that's not included with OpenAIKit
    guard let newMessage = completion.choices.first?.text else { throw OpenAiError.noResponseFound }

    return newMessage
}
~~~~

The code above will interact with the davinci GPT3 model. While this model will work for basic use cases, it is not the best option for full conversations because it does not allow for ChatGPT to be aware of previous messages after a new one is sent. For full conversations, a good option is to use the gpt-3.5-turbo model mentioned below. For more info on the models offered by Open AI, many of which have been incorporated into OpenAIKit, see: https://platform.openai.com/docs/models/overview

### Advanced Chat

Here's an example of functionality in a SwiftUI view model that sends a message to ChatGPT and fetches a response. Both the user's message and ChatGPT's response are stored in an array of type `[Chat.Message]`, which is passed to the `create` method's `messages` property so that ChatGPT can analyze the context of the conversation before responding:

~~~~swift
import OpenAIKit

@Published var messages = [Chat.Message]()

func sendMessage(withText text: String) async {
    do {
        messages.append(Chat.Message.user(content: text))
        let response = try await getResponse()
        messages.append(response)
    } catch {
        print(error)
    }
}

func getResponse() async throws -> Chat.Message {
    let completion = try await openAiClient.chats.create(
        model: Model.GPT3.gpt3_5Turbo,
        messages: messages
    )

    // OpenAiError is a custom type created for this example that's not included with OpenAIKit
    guard let newMessage = completion.choices.first?.message else { throw OpenAiError.noResponseFound }
    // If the message was fetched successfully, it will use the assistant(content:) case in Chat.Message, where content is a string containing the message text

    return newMessage
}
~~~~

### Tokens

Every interaction with the OpenAI API requires a certain amount of tokens. By default, the maximum number of tokens allowed per interaction is set to 16, which will only allow the API to respond with very short responses (by default, responses that require more than 16 tokens will be truncated). To increase this maximum number of tokens, use the `maxTokens` parameter on the `create` method like this:

~~~~swift
import OpenAIKit

let completion = try await openAIClient.completions.create(
    model: Model.GPT3.davinci,
    prompts: ["Write a haiku"],
    maxTokens: 300
)
~~~~

Your desired `maxTokens` value will depend on your use case. To determine a good value for your use case that will keep most responses from getting truncated, call the `create` method a few times while steadily increasing the `maxTokens` value and printing out `completion.usage.totalTokens`. While doing this, keep in mind that you are charged for your API usage based on how many tokens you use. To gain a thorough understanding of rate limits and how they work in conjunction with tokens, see: https://platform.openai.com/docs/guides/rate-limits/overview

### What's Implemented
* [x] [Chat](https://platform.openai.com/docs/api-reference/chat)
* [x] [Models](https://beta.openai.com/docs/api-reference/models)
* [x] [Completions](https://beta.openai.com/docs/api-reference/completions)
* [x] [Edits](https://beta.openai.com/docs/api-reference/edits)
* [x] [Images](https://beta.openai.com/docs/api-reference/images)
* [x] [Embeddings](https://beta.openai.com/docs/api-reference/embeddings)
* [x] [Files](https://beta.openai.com/docs/api-reference/files)
* [x] [Moderations](https://beta.openai.com/docs/api-reference/moderations)
* [ ] [Fine-tunes](https://beta.openai.com/docs/api-reference/fine-tunes)
* [x] [Speech to text](https://platform.openai.com/docs/guides/speech-to-text)


## Error handling
If the request to the API failed for any reason an `OpenAIKit.APIErrorResponse` is `thrown`.
Simply ensure you catch errors thrown like any other throwing function

~~~~swift
do {
   ...
} catch let error as APIErrorResponse {
    print(error)
}
~~~~
