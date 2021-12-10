import UIKit

extension UICollectionView: OhSwiftCompatible { }

public extension OhSwift where Base: UICollectionView {

    func register<T: UICollectionViewCell>(nib aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forCellWithReuseIdentifier: name)
    }

    func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forCellWithReuseIdentifier: name)
    }

    func dequeue<T: UICollectionViewCell>(_ reusableCell: T.Type, for indexPath: IndexPath) -> T {
        let name = String(describing: reusableCell)
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registered❗")
        }
        return cell
    }

    func register<T: UICollectionReusableView>(nib aClass: T.Type, for kind: String) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }

    func register<T: UICollectionReusableView>(_ aClass: T.Type, for kind: String) {
        let name = String(describing: aClass)
        base.register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }

    func dequeue<T: UICollectionReusableView>(_ reusableViewType: T.Type, of kind: String, for indexPath: IndexPath) -> T {
        let name = String(describing: reusableViewType)
        guard let view = base.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registered❗")
        }
        return view
    }
}