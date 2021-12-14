/*
 Notification 本身有很长的历史，是一套基于字符串的松散 API。
 这里通过扩展和泛型的方式，由 .toDoStoreDidChangedNotification，.toDoStoreDidChangedChangeBehaviorKey
 和 post(name:object:typedUserInfo) 以及 getUserInfo(for:)
 构成了一套更 Swifty 的类型安全的 NotificationCenter 和 userInfo 的使用方式。如果你感兴趣的话，可以参看最后的代码。
 by onevcat

 https://onevcat.com/2018/05/mvc-wrong-use/
 https://gist.github.com/onevcat/9e08111cebb1967cb96a737ed40f9f14
 */

public struct UserInfoKey<ValueType>: Hashable {
    let key: String

    public init(key: String) {
        self.key = key
    }
}

extension Notification: OhSwiftCompatible { }
public extension OhSwift where Base == Notification {

    func getUserInfo<T>(for key: UserInfoKey<T>) -> T {
        base.userInfo![key] as! T
    }
}

extension NotificationCenter: OhSwiftCompatible { }
public extension OhSwift where Base: NotificationCenter {

    func post<T>(name aName: NSNotification.Name, object anObject: Any? = nil,
                 typedUserInfo aUserInfo: [UserInfoKey<T> : T]? = nil) {
        base.post(name: aName, object: anObject, userInfo: aUserInfo)
    }

    static func post<T>(name aName: NSNotification.Name, object anObject: Any? = nil,
                        typedUserInfo aUserInfo: [UserInfoKey<T> : T]? = nil) {
        Base.default.post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}