import RxSwift

public extension ObservableType {

    func catchAndReturnEmpty(_ handler: ((Swift.Error) -> Void)? = nil) -> Observable<Element> {
        `catch` { error in
            handler?(error)
            return .empty()
        }
    }
}