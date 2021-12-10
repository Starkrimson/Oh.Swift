public struct OhSwift<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol OhSwiftCompatible {
    associatedtype OhSwiftCompatibleType
    static var oh: OhSwift<OhSwiftCompatibleType>.Type { get set }
    var oh: OhSwift<OhSwiftCompatibleType> { get set }
}

extension OhSwiftCompatible {
    public static var oh: OhSwift<Self>.Type {
        get { OhSwift<Self>.self }
        set { }
    }

    public var oh: OhSwift<Self> {
        get { OhSwift(self) }
        set { }
    }
}