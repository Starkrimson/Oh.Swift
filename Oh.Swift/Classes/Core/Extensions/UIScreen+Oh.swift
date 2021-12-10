extension UIScreen: OhSwiftCompatible { }

public extension OhSwift where Base: UIScreen {

    /// 竖屏宽
    static var portraitWidth: CGFloat {
        if let min = [UIScreen.oh.width, UIScreen.oh.height].min() {
            return min
        } else {
            return UIScreen.oh.width
        }
    }

    /// 横屏宽
    static var landscapeWidth: CGFloat {
        if let max = [UIScreen.oh.width, UIScreen.oh.height].max() {
            return max
        } else {
            return UIScreen.oh.height
        }
    }

    /// screen width
    static var width: CGFloat { UIScreen.main.bounds.width }

    /// screen height
    static var height: CGFloat { UIScreen.main.bounds.height }
}


extension CGFloat: OhSwiftCompatible { }

public extension OhSwift where Base == CGFloat {

    static var screenWidth: CGFloat { UIScreen.oh.width }
    static var screenHeight: CGFloat { UIScreen.oh.height }
}