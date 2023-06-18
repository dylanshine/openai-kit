import Foundation

/**
 Given a prompt, the model will return one or more predicted chat completions, and can also return the probabilities of alternative tokens at each position.
 */
public struct Chat {
    public let id: String
    public let object: String
    public let created: Date
    public let model: String
    public let choices: [Choice]
    public let usage: Usage
}

extension Chat: Codable {}

extension Chat {
    public struct Choice {
        public let index: Int
        public let message: Message
        public let finishReason: FinishReason?
    }
}

extension Chat.Choice: Codable {}

extension Chat {
    
    public enum FunctionMode {
        case none
        case auto
        case named(String)
    }
}

extension Chat.FunctionMode: Codable {
    
    private struct Named: Codable {
        let name: String
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            let singleStringValue = try container.decode(String.self)
            
            switch singleStringValue {
            case "none":
                self = .none
            case "auto":
                self = .auto
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid type"
                )
            }
        } catch {
            let parameterized = try Named(from: decoder)
            self = .named(parameterized.name)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .none:
            var container = encoder.singleValueContainer()
            try container.encode("none")
        case .auto:
            var container = encoder.singleValueContainer()
            try container.encode("auto")
        case .named(let string):
            try Named(name: string).encode(to: encoder)
        }
    }
}

public protocol ChatFunction: Encodable {
    associatedtype Parameters: Encodable
    
    var name: String { get }
    var description: String? { get }
    var parameters: Parameters? { get }
}

public protocol ChatFunctionCall: Codable {
    var name: String { get }
    init(name: String)
}

public protocol ChatFunctionCallWithArguments: Codable {
    associatedtype Arguments: Codable
    
    var name: String { get }
    var arguments: Arguments { get }
    
    init(name: String, arguments: Arguments)
}

public struct UnstructuredChatFunctionCall: Codable {
    let name: String
    let arguments: String?
    
    public func structured<T: ChatFunctionCall>(as callType: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        callType.init(name: name)
    }
    
    public func structured<T: ChatFunctionCallWithArguments>(as callType: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        if let arguments {
            let data = Data(arguments.utf8)
            let parsedArgs = try decoder.decode(callType.Arguments, from: data)
            return callType.init(name: name, arguments: parsedArgs)
        }
        throw NSError(domain: "", code: -1)
    }
}

public extension Chat {
    typealias Function = ChatFunction
    typealias UnstructuredFunctionCall = UnstructuredChatFunctionCall
    typealias FunctionCall = ChatFunctionCall
    typealias FunctionCallWithArguments = ChatFunctionCallWithArguments
}

extension Chat {
    
    public enum Message {
        case system(content: String)
        case user(content: String)
        case assistant(content: String)
        case assistantWithCall(content: String?, call: UnstructuredFunctionCall)
        case function(content: String?, name: String, call: UnstructuredFunctionCall?)
    }
}

extension Chat.Message: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case functionCall
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(String.self, forKey: .role)
        
        switch role {
        case "system":
            let content = try container.decode(String.self, forKey: .content)
            self = .system(content: content)
        case "user":
            let content = try container.decode(String.self, forKey: .content)
            self = .user(content: content)
        case "assistant":
            
            if let call = try container.decodeIfPresent(UnstructuredChatFunctionCall.self, forKey: .functionCall) {
                let content = try container.decodeIfPresent(String.self, forKey: .content)
                self = .assistantWithCall(content: content, call: call)
                
            } else {
                
                let content = try container.decode(String.self, forKey: .content)
                self = .assistant(content: content)
            }
            
        case "function":
            
            let call = try container.decodeIfPresent(UnstructuredChatFunctionCall.self, forKey: .functionCall)
            
            let content = try container.decodeIfPresent(String.self, forKey: .content)
            let name = try container.decode(String.self, forKey: .name)
            self = .function(content: content, name: name, call: call)
        default:
            throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .system(let content):
            try container.encode("system", forKey: .role)
            try container.encode(content, forKey: .content)
        case .user(let content):
            try container.encode("user", forKey: .role)
            try container.encode(content, forKey: .content)
        case .assistant(let content):
            try container.encode("assistant", forKey: .role)
            try container.encode(content, forKey: .content)
        case let .assistantWithCall(content, call):
            try container.encode("assistant", forKey: .role)
            try container.encode(call, forKey: .functionCall)
            try container.encodeIfPresent(content, forKey: .content)
        case let .function(content, name, call):
            try container.encode("function", forKey: .role)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(call, forKey: .functionCall)
            try container.encodeIfPresent(content, forKey: .content)
        }
    }
}

extension Chat.Message {
    
    public var content: String {
        get {
            switch self {
            case .system(let content), .user(let content), .assistant(let content):
                return content
            case .assistantWithCall(let content, _), .function(let content, _, _):
                return content ?? ""
            }
        }
        set {
            switch self {
            case .system: self = .system(content: newValue)
            case .user: self = .user(content: newValue)
            case .assistant: self = .assistant(content: newValue)
            case let .function(_, name, call):
                self = .function(content: newValue, name: name, call: call)
            case let .assistantWithCall(_, call):
                self = .assistantWithCall(content: newValue, call: call)
            }
        }
    }
}
