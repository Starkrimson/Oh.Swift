import UIKit

public extension OhSwift where Base: UITableView {

    func register<T: UITableViewCell>(nib aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        base.register(nib, forCellReuseIdentifier: name)
    }

    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        base.register(aClass, forCellReuseIdentifier: name)
    }

    func dequeue<T: UITableViewCell>(_ reusableCell: T.Type) -> T {
        let name = String(describing: reusableCell)
        guard let cell = base.dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registered❗️")
        }
        return cell
    }
}
