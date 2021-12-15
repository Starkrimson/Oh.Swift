import RxSwift
import RxCocoa


public extension Reactive where Base: UITableView {

    /// 在原 modelSelected 基础上返回 IndexPath
    ///
    ///  tableView.rx.modelSelectedAtIndexPath(String.self)
    ///            .subscribe(onNext: { (element, indexPath) in })
    ///     ...
    ///
    func modelSelectedAtIndexPath<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        let source: Observable<(T, IndexPath)> = itemSelected
            .flatMap { [weak view = base as UITableView] indexPath -> Observable<(T, IndexPath)> in
                guard let view = view else {
                    return Observable.empty()
                }

                return Observable.just((try view.rx.model(at: indexPath), indexPath))
            }

        return ControlEvent(events: source)
    }


    /// 简化 items(cellIdentifier:,cellType:)
    /// 可配合 tableView.oh.register(UITableViewCell.self) 使用
    ///
    /// Example:
    ///
    ///     items
    ///        .bind(to: tableView.rx.items(cell: UITableViewCell.self)) { (row, element, cell) in
    ///            cell.textLabel?.text = "\(row) - \(element)"
    ///        }
    ///        .disposed(by: rx.disposeBag)
    ///
    /// - Parameter type: Type of table view cell.
    /// - Returns: Disposable object that can be used to unbind.
    func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>
        (cell type: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Iterator.Element, Cell) -> Void)
        -> Disposable where Source.Element == Sequence {
            let cellIdentifier = String(describing: type)
            return items(cellIdentifier: cellIdentifier, cellType: type)
    }
}