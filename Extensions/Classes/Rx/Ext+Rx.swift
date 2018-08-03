import RxSwift
import RxCocoa

private var disposeBagContext: UInt8 = 0

extension Reactive where Base: AnyObject {
    
    private func synchroizedBag<T>(_ action: () -> T) -> T {
        objc_sync_enter(base)
        let result = action()
        objc_sync_exit(base)
        return result
    }
    
    public var disposeBag: DisposeBag {
        get {
            return synchroizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        set {
            synchroizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension Reactive where Base: UITableView {

    public func modelSelectedAtIndexPath<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        let source: Observable<(T, IndexPath)> = self.itemSelected.flatMap { [weak view = self.base as UITableView] indexPath -> Observable<(T, IndexPath)> in
            guard let view = view else {
                return Observable.empty()
            }

            return Observable.just((try view.rx.model(at: indexPath), indexPath))
        }

        return ControlEvent(events: source)
    }
}
