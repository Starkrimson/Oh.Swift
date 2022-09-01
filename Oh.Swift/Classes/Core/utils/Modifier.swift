@available(*, deprecated, renamed: "Modifier", message: "PropertyConfig has been renamed Modifier.")
public typealias PropertyConfig = Modifier

public struct Modifier<Base> {
    public let rawValue: Base
    public init(_ rawValue: Base) {
        self.rawValue = rawValue
    }
}

public extension Modifier where Base: UIView {

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

    @discardableResult
    func clipsToBounds(_ flag: Bool) -> Self {
        rawValue.clipsToBounds = flag
        return self
    }

    @discardableResult
    func tag(_ tag: Int) -> Self {
        rawValue.tag = tag
        return self
    }
    
    @discardableResult
    func tapAction(handler: @escaping () -> ()) -> Self {
        let tap = UITapGestureRecognizer()
        tap.addTarget(
            ControlEventHandler(rawValue, handler: handler),
            action: #selector(ControlEventHandler.eventHandler)
        )
        rawValue.addGestureRecognizer(tap)
        rawValue.isUserInteractionEnabled = true
        return self
    }
}

public extension Modifier where Base: UILabel {

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
    func preferredFont(
        _ style: UIFont.TextStyle,
        compatibleWith traitCollection: UITraitCollection? = nil) -> Self {
        if #available(iOS 10.0, *) {
            rawValue.font = .preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        } else {
            rawValue.font = .preferredFont(forTextStyle: style)
        }
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


class ControlEventHandler {
    let handler: () -> ()
    
    init(_ target: Any, handler: @escaping () -> ()) {
        self.handler = handler
        objc_setAssociatedObject(target, "ControlEventHandler[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func eventHandler() {
        handler()
    }
}

public extension Modifier where Base: UIControl {

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
    
    @discardableResult
    @available(iOS 14.0, *)
    func action(for controlEvents: UIControl.Event = .touchUpInside, handler: @escaping UIActionHandler) -> Self {
        let action = UIAction(title: "", handler: handler)
        rawValue.addAction(action, for: controlEvents)
        return self
    }
    
    @discardableResult
    @available(iOS 14.0, *)
    func action(_ action: UIAction, for controlEvents: UIControl.Event = .touchUpInside) -> Self {
        rawValue.addAction(action, for: controlEvents)
        return self
    }
    
    @discardableResult
    func action(for controlEvents: UIControl.Event = .touchUpInside, handler: @escaping () -> ()) -> Self {
        rawValue.addTarget(
            ControlEventHandler(rawValue, handler: handler),
            action: #selector(ControlEventHandler.eventHandler),
            for: controlEvents
        )
        return self
    }
}

public extension Modifier where Base: UIButton {

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
    func attributedTitle(_ title: NSAttributedString?, for state: UIButton.State = .normal) -> Self {
        rawValue.setAttributedTitle(title, for: state)
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

public extension Modifier where Base: UITextField {

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
    func placeholder(_ text: String) -> Self {
        rawValue.placeholder = text
        return self
    }

    @discardableResult
    func placeholder(_ attributedText: NSAttributedString) -> Self {
        rawValue.attributedPlaceholder = attributedText
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
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        rawValue.borderStyle = style
        return self
    }

    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        rawValue.clearButtonMode = mode
        return self
    }

    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        rawValue.keyboardType = type
        return self
    }

    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        rawValue.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func adjustsFontSizeToFitWidth(_ flag: Bool) -> Self {
        rawValue.adjustsFontSizeToFitWidth = flag
        return self
    }

    @discardableResult
    func isSecureTextEntry(_ flag: Bool) -> Self {
        rawValue.isSecureTextEntry = flag
        return self
    }
}

public extension Modifier where Base: UITextView {

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
    func keyboardType(_ type: UIKeyboardType) -> Self {
        rawValue.keyboardType = type
        return self
    }

    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        rawValue.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func isSecureTextEntry(_ flag: Bool) -> Self {
        rawValue.isSecureTextEntry = flag
        return self
    }
}

public extension Modifier where Base: UIImageView {

    @discardableResult
    func image(_ image: UIImage?) -> Self {
        rawValue.image = image
        return self
    }

    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        rawValue.highlightedImage = image
        return self
    }

    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        rawValue.contentMode = mode
        return self
    }
}

public extension Modifier where Base: UITableView {

    @discardableResult
    func register<T: UITableViewCell>(nib aClass: T.Type) -> Self {
        rawValue.oh.register(nib: aClass)
        return self
    }

    @discardableResult
    func register<T: UITableViewCell>(_ aClass: T.Type) -> Self {
        rawValue.oh.register(aClass)
        return self
    }

    @discardableResult
    func separator(style: UITableViewCell.SeparatorStyle = .singleLine,
                   color: UIColor? = nil,
                   inset: UIEdgeInsets? = nil) -> Self {
        rawValue.separatorStyle = style
        if let inset = inset {
            rawValue.separatorInset = inset
        }
        if let color = color {
            rawValue.separatorColor = color
        }
        return self
    }
}

public extension Modifier where Base: UISwitch {

    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        rawValue.onTintColor = color
        return self
    }
}
