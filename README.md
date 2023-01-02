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

Register the config and the provider.

~~~~swift
let httpClient = HTTPClient(...)
let configuration = Configuration(apiKey: "YOUR_API_KEY", organization: "YOUR_ORGANIZATION")

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
If the request to the API failed for any reason an `OpenAIKit.APIError` is `thrown`.
Simply ensure you catch errors thrown like any other throwing function

~~~~swift
do {
   ...
} catch let error as APIError {
    print(error)
}
~~~~
