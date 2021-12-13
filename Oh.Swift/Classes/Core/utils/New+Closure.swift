import Foundation

extension UIView: OhSwiftCompatible { }

public extension OhSwift where Base: UIView {

    /// 初始化并在 closure 回调设置属性
    ///
    ///    let button = UIButton.oh.new {
    ///        $0.setTitle("Done", for: .normal)
    ///        $0.setTitleColor(.black, for: .normal)
    ///    }
    static func new(_ closure: (Base) throws -> Void) rethrows -> Base {
        let base = Base.init()
        try closure(base)
        return base
    }
}