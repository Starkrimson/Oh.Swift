
public struct PropertyConfig<Base> {
    public let rawValue: Base
    public init(_ rawValue: Base) {
        self.rawValue = rawValue
    }
}

public extension PropertyConfig where Base: UIView {

    @discardableResult
    func superView(_ view: UIView) -> Self {
        view.addSubview(rawValue)
        return self
    }

    @discardableResult
    func background(color: UIColor) -> Self {
        rawValue.backgroundColor = color
        return self
    }

    @discardableResult
    func border(color: UIColor = .black, width: CGFloat = 1) -> Self {
        rawValue.layer.borderColor = color.cgColor
        rawValue.layer.borderWidth = width
        return self
    }

    @discardableResult
    func corner(radius: CGFloat) -> Self {
        rawValue.layer.cornerRadius = radius
        return self
    }

    @discardableResult
    @available(iOS 11.0, *)
    func corner(radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        rawValue.layer.cornerRadius = radius
        rawValue.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        return self
    }
}

public extension PropertyConfig where Base: UILabel {

    @discardableResult
    func text(_ text: String?) -> Self {
        rawValue.text = text
        return self
    }

    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        rawValue.textColor = color
        return self
    }

    @discardableResult
    func font(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        rawValue.font = .systemFont(ofSize: size, weight: weight)
        return self
    }

    @discardableResult
    func font(_ font: UIFont) -> Self {
        rawValue.font = font
        return self
    }
}

public extension PropertyConfig where Base: UIButton {

    @discardableResult
    func titleColor(_ color: UIColor, for state: UIButton.State = .normal) -> Self {
        rawValue.setTitleColor(color, for: state)
        return self
    }
}