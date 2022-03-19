import Foundation

extension UIView: OhSwiftCompatible { }

public extension OhSwift where Base: UIView {

    /// 初始化并在 closure 回调设置属性
    ///
    ///    UIView.oh.new { make in
    ///           make.background(color: .white)
    ///               .border(width: 10)
    ///               .corner(radius: 20)
    ///           if #available(iOS 11.0, *) {
    ///               make.corner(radius: 20, corners: [.topLeft, .bottomRight])
    ///           }
    ///           make.view.frame = .init(x: 50, y: 650, width: 100, height: 100)
    ///       }
    static func new(_ closure: (Modifier<Base>) throws -> Void) rethrows -> Base {
        let base = Base.init()
        try closure(Modifier(base))
        return base
    }

    var modifier: Modifier<Base> {
        Modifier(base)
    }

    @available(*, deprecated, renamed: "modifier")
    var config: PropertyConfig<Base> {
        PropertyConfig(base)
    }
}