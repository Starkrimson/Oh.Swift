
@available(*, deprecated, message: "Please use `po` as a replacement.")
public func debugLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    print("-------\n",
          (file as NSString).lastPathComponent,
          "[\(line)],",
          "\(method):\n \(message)",
          "\n-------")
    #endif
}

public enum POStyle: String {
    case normal = "", warning = "⚠️", error = "❗️"
}

public func po(_ items: Any...,
    id: String? = nil,
    style: POStyle = .normal,
    file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    func p(_ items: Any..., terminator: String = " ") {
        items.forEach {
            print($0, terminator: terminator)
        }
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS:"
    let dateString = dateFormatter.string(from: Date())
    p(dateString)
    
    if let identifier = id {
        p(identifier)
    } else {
        p("\((file as NSString).lastPathComponent):\(line).\(method)")
    }
    
    if style != .normal {
        p(style.rawValue)
    }
    
    p("->")
    items.forEach { p($0) }
    print()
    
    #endif
}
