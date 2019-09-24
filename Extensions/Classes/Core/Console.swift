
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

public enum POStyle {
    case normal, warning, error
    case shamrock
    case custom(emoji: String)
    
    var value: String {
        switch self {
        case .normal: return ""
        case .shamrock: return "☘️"
        case .warning: return "⚠️"
        case .error: return "❗️"
        case .custom(let emoji): return emoji
        }
    }
    
    var isNormal: Bool {
        if case POStyle.normal = self {
            return true
        } else {
            return false
        }
    }
}

public func po(_ items: Any...,
    id: String? = nil,
    style: POStyle = .shamrock,
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
    
    if !style.isNormal {
        p(style.value)
    }

    if let identifier = id {
        p(identifier)
    } else {
        p("\((file as NSString).lastPathComponent):\(line).\(method)")
    }
    
    p("->")
    items.forEach { p($0) }
    print()
    
    #endif
}
