//
//  MessageTests.swift
//
//
//  Created by Ronald Mannak on 3/6/23.
//
import XCTest
@testable import OpenAIKit

final class MessageTests: XCTestCase {

    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    override func setUpWithError() throws {
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFinishReasonContentFilterCoding() throws {
        let filter: FinishReason = .contentFilter
        let encoded = try encoder.encode(filter)
        XCTAssertEqual("\"content_filter\"", String(data: encoded, encoding: .utf8)!)

        let decoded = try decoder.decode(FinishReason.self, from: encoded)
        XCTAssertEqual(decoded, FinishReason.contentFilter)
        XCTAssertNotEqual(decoded, FinishReason.length)
        XCTAssertNotEqual(decoded, FinishReason.stop)
    }

    func testFinishReasonLengthCoding() throws {
        let filter: FinishReason = .length
        let encoded = try encoder.encode(filter)
        XCTAssertEqual("\"length\"", String(data: encoded, encoding: .utf8)!)

        let decoded = try decoder.decode(FinishReason.self, from: encoded)
        XCTAssertEqual(decoded, FinishReason.length)
        XCTAssertNotEqual(decoded, FinishReason.contentFilter)
        XCTAssertNotEqual(decoded, FinishReason.stop)
    }

    func testFinishStopCoding() throws {
        let filter: FinishReason = .stop
        let encoded = try encoder.encode(filter)
        XCTAssertEqual("\"stop\"", String(data: encoded, encoding: .utf8)!)

        let decoded = try decoder.decode(FinishReason.self, from: encoded)
        XCTAssertEqual(decoded, FinishReason.stop)
        XCTAssertNotEqual(decoded, FinishReason.contentFilter)
        XCTAssertNotEqual(decoded, FinishReason.length)
    }


    func testMessageCoding() throws {
        let messageData = """
            {"role": "user", "content": "Translate the following English text to French: "}
            """.data(using: .utf8)!
        let message = try decoder.decode(Chat.Message.self, from: messageData)
        switch message {
        case .system(_):
            XCTFail("incorrect role")
        case .user(let content):
            XCTAssertEqual(content, "Translate the following English text to French: ")
        case .assistant(_):
            XCTFail("incorrect role")
        }
    }

    func testMessageRoundtrip() throws {
        let message = Chat.Message.system(content: "You are a helpful assistant that translates English to French.")
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(Chat.Message.self, from: encoded)
        print(String(data: encoded, encoding: .utf8)!)
        switch decoded {
        case .system(let content):
            guard case let .system(content: original) = message else {
                XCTFail()
                return
            }
            XCTAssertEqual(content, original)
        case .user(_):
            XCTFail("incorrect role")
        case .assistant(_):
            XCTFail("incorrect role")
        }
    }

    func testChatDecoding() throws {
        let exampleResponse = """
            {
             "id": "chatcmpl-6p9XYPYSTTRi0xEviKjjilqrWU2Ve",
             "object": "chat.completion",
             "created": 1677649420,
             "model": "gpt-3.5-turbo",
             "usage": {"prompt_tokens": 56, "completion_tokens": 31, "total_tokens": 87},
             "choices": [
               {
                "message": {
                  "role": "assistant",
                  "content": "The 2020 World Series was played in Arlington, Texas at the Globe Life Field, which was the new home stadium for the Texas Rangers."},
                "finish_reason": "stop",
                "index": 0
               }
              ]
            }
            """.data(using: .utf8)!
        let chat = try decoder.decode(Chat.self, from: exampleResponse)
//        XCTAssertEqual(chat.id, "chatcmpl-6p9XYPYSTTRi0xEviKjjilqrWU2Ve")
//        XCTAssertEqual(chat.created.timeIntervalSince1970, 1677649420)
//        XCTAssertEqual(chat.usage.promptTokens, 56)
//        XCTAssertEqual(chat.usage.completionTokens, 31)
//        XCTAssertEqual(chat.usage.totalTokens, 87)

        XCTAssertEqual(chat.choices.count, 1)
        let firstChoice = chat.choices.first!
        XCTAssertEqual(firstChoice.index, 0)
        switch firstChoice.message {
        case .system(_):
            XCTFail()
        case .assistant(let content):
            XCTAssertEqual(content, "The 2020 World Series was played in Arlington, Texas at the Globe Life Field, which was the new home stadium for the Texas Rangers.")
        case .user(_):
            XCTFail()
        }
    }
    
    func testChatRequest() throws {
        let request = try CreateChatRequest(
            model: "gpt-3.5-turbo", //.gpt3_5Turbo,
            messages: [
                .system(content: "You are Malcolm Tucker from The Thick of It, an unfriendly assistant for writing mail and explaining science and history. You write text in your voice for me."),
                .user(content: "tell me a joke"),
            ],
            temperature: 1.0,
            topP: 1.0,
            n: 1,
            stream: false,
            stops: [],
            maxTokens: nil,
            presencePenalty: 0.0,
            frequencyPenalty: 0.0,
            logitBias: [:],
            user: nil
        )
        
        print(request.body)
    }
}
