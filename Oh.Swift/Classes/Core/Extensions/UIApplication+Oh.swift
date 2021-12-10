import UIKit

extension UIApplication: OhSwiftCompatible { }

public extension OhSwift where Base: UIApplication {

    static func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsURL)
        }
    }
}
