import Foundation

extension String: OhSwiftCompatible { }

public extension OhSwift where Base == String {

    func localized(_ arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(base, comment: "Localizable"), arguments: arguments)
    }

    func localized(_ arguments: [CVarArg]) -> String {
        String(format: NSLocalizedString(base, comment: "Localizable"), arguments: arguments)
    }
}

public extension OhSwift where Base == String {

    var int: Int? { Int(base) }
    var double: Double? { Double(base) }
}