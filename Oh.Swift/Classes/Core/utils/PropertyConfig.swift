
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
    func frame(_ rect: CGRect) -> Self {
        rawValue.frame = rect
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

    @discardableResult
    func isHidden(_ hidden: Bool) -> Self {
        rawValue.isHidden = hidden
        return self
    }

    @discardableResult
    func toggleHidden() -> Self {
        rawValue.isHidden = !rawValue.isHidden
        return self
    }

    @discardableResult
    func isUserInteractionEnabled(_ flag: Bool) -> Self {
        rawValue.isUserInteractionEnabled = flag
        return self
    }

    @discardableResult
    func toggleUserInteractionEnabled() -> Self {
        rawValue.isUserInteractionEnabled = !rawValue.isUserInteractionEnabled
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
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        rawValue.attributedText = attributedText
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

    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        rawValue.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> Self {
        rawValue.numberOfLines = numberOfLines
        return self
    }

    @discardableResult
    func adjustsFontSizeToFitWidth(_ flag: Bool) -> Self {
        rawValue.adjustsFontSizeToFitWidth = flag
        return self
    }
}

public extension PropertyConfig where Base: UIControl {

    @discardableResult
    func isEnabled(_ enabled: Bool) -> Self {
        rawValue.isEnabled = enabled
        return self
    }

    @discardableResult
    func toggleEnable() -> Self {
        rawValue.isEnabled = !rawValue.isEnabled
        return self
    }

    @discardableResult
    func target(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        rawValue.addTarget(target, action: action, for: controlEvents)
        return self
    }
}

public extension PropertyConfig where Base: UIButton {

    @discardableResult
    func title(_ title: String?, for state: UIButton.State = .normal) -> Self {
        rawValue.setTitle(title, for: state)
        return self
    }

    @discardableResult
    func titleColor(_ color: UIColor, for state: UIButton.State = .normal) -> Self {
        rawValue.setTitleColor(color, for: state)
        return self
    }

    @discardableResult
    func font(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        rawValue.titleLabel?.font = .systemFont(ofSize: size, weight: weight)
        return self
    }

    @discardableResult
    func font(_ font: UIFont) -> Self {
        rawValue.titleLabel?.font = font
        return self
    }

    @discardableResult
    func image(_ image: UIImage?, for state: UIButton.State = .normal) -> Self {
        rawValue.setImage(image, for: state)
        return self
    }

    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIButton.State = .normal) -> Self {
        rawValue.setBackgroundImage(image, for: state)
        return self
    }
}