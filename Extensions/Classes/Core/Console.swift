
@available(*, deprecated, message: "Please use `ex.po` as a replacement.")
public func debugLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    print("-------\n",
          (file as NSString).lastPathComponent,
          "[\(line)],",
          "\(method):\n \(message)",
          "\n-------")
    #endif
}
