// from 喵神 - 使用 Property Wrapper 为 Codable 解码设定默认值
// https://onevcat.com/2020/11/codable-default/
// https://gist.github.com/onevcat/0f055ece50bd0c07e882890129dfcfb8

import Foundation

@propertyWrapper
public struct Default<T: DefaultValue>: Codable {
    public var wrappedValue: T.Value

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }

    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

extension KeyedDecodingContainer {
    public func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

extension Bool: DefaultValue {
    public static var defaultValue = false

    public enum False: DefaultValue {
        public static let defaultValue = false
    }

    public enum True: DefaultValue {
        public static let defaultValue = true
    }
}

extension String: DefaultValue {
    public static var defaultValue = ""
}

extension Int: DefaultValue {
    public static var defaultValue = 0
}

extension Double: DefaultValue {
    public static var defaultValue = 0.0
}

extension Array: DefaultValue where Element: Codable {
    public static var defaultValue: Array<Element> { [] }
}

// MARK: - typealias
extension Default {
    public typealias True = Default<Bool.True>
    public typealias False = Default<Bool.False>
}

// MARK: - Demo
private struct ModelDemo: Codable {

    enum State: Int, Codable, DefaultValue {

        case unknown = -99
        case steaming = 0
        case archived

        static let defaultValue = State.unknown
    }

    @Default<String> var str: String
    @Default<[String]> var list: [String]
    @Default<State> var state: State

    @Default.True var flag: Bool

    @Default<[ModelDemo]> var list1: [ModelDemo]
}
