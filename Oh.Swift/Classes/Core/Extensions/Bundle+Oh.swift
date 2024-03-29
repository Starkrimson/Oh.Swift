import Foundation

extension Bundle: OhSwiftCompatible { }

public extension OhSwift where Base: Bundle {

    /// App display name
    static var displayName: String {
        Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
                ?? Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
                ?? ""
    }

    /// App version
    static var marketingVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// App build number
    static var buildVersion: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    /// Sandbox path
    static var documentDirectory: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}

public extension OhSwift where Base == String {

    static var appName: String { Bundle.oh.displayName }
    static var appVersion: String { Bundle.oh.marketingVersion }
    static var appBuild: String { Bundle.oh.buildVersion }
}