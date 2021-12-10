
extension UIColor: OhSwiftCompatible { }

public extension OhSwift where Base: UIColor {

    /// 16 进制颜色
    /// - Parameter hex: 0xFFFFFF
    /// - Parameter alpha: 透明度 0.0 ~ 1.0
    /// - Returns: UIColor
    static func hex(_ hex: UInt32, alpha: CGFloat = 1) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor.oh.rgb(r: r, g: g, b: b, alpha: alpha)
    }

    /// 随机颜色
    static var random: UIColor {
        UIColor.oh.rgb(r: arc4random_uniform(256), g: arc4random_uniform(256), b: arc4random_uniform(256))
    }

    /// 返回 UIColor 的颜色数值，0 ~ 1。
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let ciColor = CIColor(cgColor: base.cgColor)
        return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
    }

    /// rgba 0 ~ 255
    static func rgb(r: UInt32, g: UInt32, b: UInt32, alpha: CGFloat = 1) -> UIColor {
        UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }

    /// white 0 ~ 255
    static func white(_ white: UInt32, alpha: CGFloat = 1) -> UIColor {
        UIColor(white: CGFloat(white)/255.0, alpha: alpha)
    }
}