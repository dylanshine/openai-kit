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

Create a `OpenAIKit.Client` using a httpClient and configuration.

~~~~swift

var apiKey: String {
    ProcessInfo.processInfo.environment["OPENAI_API_KEY"]!
}

var organization: String {
    ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"]!
}

...

let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
let configuration = Configuration(apiKey: apiKey, organization: organization)

let openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
~~~~

## Using the API

The OpenAIKit.Client implements a handful of methods to interact with the OpenAI API:

~~~~swift
import OpenAIKit

let completion = try await openAIClient.completions.create(
    model: Model.GPT3.davinci,
    prompts: ["Write a haiku"]
)
~~~~

### What's Implemented
* [x] [Models](https://beta.openai.com/docs/api-reference/models)
* [x] [Completions](https://beta.openai.com/docs/api-reference/completions)
* [x] [Edits](https://beta.openai.com/docs/api-reference/edits)
* [x] [Images](https://beta.openai.com/docs/api-reference/images)
* [x] [Embeddings](https://beta.openai.com/docs/api-reference/embeddings)
* [x] [Files](https://beta.openai.com/docs/api-reference/files)
* [x] [Moderations](https://beta.openai.com/docs/api-reference/moderations)
* [ ] [Fine-tunes](https://beta.openai.com/docs/api-reference/fine-tunes)


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
