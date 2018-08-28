import SnapKit

@available(iOS 9.0, *)
public extension Extensions where Base: UILayoutGuide {
    
}

extension UIView: ExtensionsCompatible { }
public extension Extensions where Base: UIView {
    
    @available(iOS 11.0, *)
    func makeSafeAreaContraints(offset: UIEdgeInsets = .zero) {
        base.snp.makeConstraints { (make) in
            make.top.equalTo(base.superview!.safeAreaLayoutGuide.snp.top).offset(offset.top)
            make.left.equalTo(base.superview!.safeAreaLayoutGuide.snp.left).offset(offset.left)
            make.right.equalTo(base.superview!.safeAreaLayoutGuide.snp.right).offset(-offset.right)
            make.bottom.equalTo(base.superview!.safeAreaLayoutGuide.snp.bottom).offset(-offset.bottom)
        }
    }
}
