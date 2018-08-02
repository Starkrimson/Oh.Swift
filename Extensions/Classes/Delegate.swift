/// 喵神的 `An auto-weak delegate for handle modern delegate pattern.`
/// https://gist.github.com/onevcat/3c8f7c4e8c96f288854688cf34111636
public class Delegate<Input, Output> {
    private var block: ((Input) -> Output?)?
    
    public func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }
    
    public func call(_ input: Input) -> Output? {
        return block?(input)
    }
    
    public init() { }
}

public extension Delegate where Input == Void {
    public func call() -> Output? {
        return call(())
    }
}

