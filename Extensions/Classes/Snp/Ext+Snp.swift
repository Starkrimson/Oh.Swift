import SnapKit

@available(iOS 9.0, *)
public extension Extensions where Base: UILayoutGuide {
    
    func layoutConstraintItem() {
        print("...")
    }
}

extension UIView: ExtensionsCompatible { }
public extension Extensions where Base: UIView {
    
    @available(iOS 11.0, *)
    func safeAreaContraints() {
        base.snp.makeConstraints { (make) in
//            make.top.equalTo(base.superview!.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(base.superview!.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(base.superview!.safeAreaLayoutGuide.snp.right)
//            make.bottom.equalTo(base.superview!.safeAreaLayoutGuide.snp.bottom)
            make.left.right.bottom.top.equalTo(base.superview!.safeAreaLayoutGuide)
        }
    }
}
