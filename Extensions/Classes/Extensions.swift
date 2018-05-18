public protocol StateType { }
public protocol ActionType { }
public protocol CommandType { }

public class Store<S: StateType, A: ActionType, C: CommandType> {
    let reducer: (_ state: S, _ action: A) -> (S, C?)
    var subscriber: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    var state: S
    
    init(reducer: @escaping (S, A) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        let (newState, command) = reducer(previousState, action)
        state = newState
        subscriber?(state, previousState, command)
    }
    
    func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscriber = handler
    }
    
    func unsubscribe() {
        self.subscriber = nil
    }
}

public extension UIColor {
    
    static var darkBlue: UIColor {
        return UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    }
    
    static var lightBlue: UIColor {
        return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    static var dusk: UIColor {
        return UIColor(red: 255/255.0, green: 181/255.0, blue: 68/255.0, alpha: 1.0)
    }
    
    static var customOrange: UIColor {
        return UIColor(red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 1.0)
    }
    
    static var random: UIColor {
        return UIColor.rgb(r: arc4random_uniform(256), g: arc4random_uniform(256), b: arc4random_uniform(256))
    }
    
    static func hex(_ hex: UInt32) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor.rgb(r: r, g: g, b: b)
    }
    
    static func rgb(r: UInt32, g: UInt32, b: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    static func white(_ white: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(white: CGFloat(white)/255.0, alpha: alpha)
    }
}

public extension UIImage {
    
    func makeCircularImage(size: CGSize, borderWidth width: CGFloat) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)
        
        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
        
        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)
        
        // clip to the circle
        circle.addClip()
        
        UIColor.white.set()
        circle.fill()
        
        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)
        
        // create a border (for white background pictures)
        if width > 0 {
            circle.lineWidth = width;
            UIColor.white.set()
            circle.stroke()
        }
        
        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext();
        
        return roundedImage ?? self
    }
    
    func create(size: CGSize? = nil, backgroundColor: UIColor = UIColor.white) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backgroundColor.setFill()
        UIRectFill(rect)
        
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
        
    }
    
    /// 屏幕截图
    ///
    /// - Parameter view: 需要截图的 view
    /// - Returns: 截图
    static func screenshot(of view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension NSAttributedString {
    
    static func attributedString(string: String?, fontSize size: CGFloat, color: UIColor?) -> NSAttributedString? {
        guard let string = string else { return nil }
        
        let attributes = [NSAttributedStringKey.foregroundColor: color ?? UIColor.black,
                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: size)]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    static func attributedString(string: String?, font: UIFont, color: UIColor?) -> NSAttributedString? {
        guard let string = string else { return nil }
        
        let attributes = [NSAttributedStringKey.foregroundColor: color ?? UIColor.black,
                          NSAttributedStringKey.font: font]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
}

public extension CGPoint {
    
    var commitTranslation: UISwipeGestureRecognizerDirection? {
        let absX = fabs(self.x)
        let absY = fabs(self.y)
        
        guard absX + absY > 0.0 else {
            return nil
        }
        
        if absX > absY {
            if self.x < 0 {
                return .left
            }else{
                return .right
            }
            
        } else if absY > absX {
            if self.y < 0 {
                return .up
            }else{
                return .down
            }
        }
        return nil
    }
}

public extension URL {
    func copyItem(to dstURL: URL) {
        try? FileManager.default.copyItem(at: self, to: dstURL)
    }
}

public extension String {
    
    var isUrlSupported: Bool {
        return self.hasPrefix("http://") || self.hasPrefix("https://")
    }
    
    func draw(in rect: CGRect, withAttributes: [String: Any]?) {
        self.draw(in: rect, withAttributes: withAttributes)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(margin: CGFloat, fontSize: CGFloat) -> CGFloat {
        return heightWithConstrainedWidth(width: UIScreen.width - margin, font: UIFont.systemFont(ofSize: fontSize))
    }
    
    func copyItem(toPath dstPath: String) {
        try? FileManager.default.copyItem(atPath: self, toPath: dstPath)
    }
    
    /// 路径拼接
    ///
    /// - Parameters:
    ///   - lhs: 原路径
    ///   - rhs: 文件夹或者文件名
    /// - Returns: 新路径
    /// eg. "/Doc"/"folder"/"fileName.md" --> "/Doc/folder/fileName.md"
    static func /(lhs: String, rhs: String) -> String {
        return lhs + "/" + rhs
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: "Localizable"), arguments: arguments)
    }
    
    var encode: String? {
        let characterSet = NSCharacterSet(charactersIn: "!*'\\\\\"();:@&=+$,/?%#[]% ")
        return self.contains("/") ? self.addingPercentEncoding(withAllowedCharacters: characterSet.inverted) : self
    }
    
    var decode: String? {
        return self.removingPercentEncoding
    }
    
    /// 计算当前 option 在 options 内的 index
    ///
    /// - Parameter options: 选项列表
    /// - Returns: indexPath
    func calculateIndexPath(in options: [[String]], isIncludeSection: Bool = false) -> IndexPath? {
        let sectionOfOptions = options.filter { (arr) -> Bool in
            arr.contains(self)
        }
        guard let sectionValue = sectionOfOptions.first,
            let section = options.index(where: {$0 == sectionValue}),
            let row = sectionValue.index(where: {$0 == self})
            else {
                return nil
        }
        
        return IndexPath(row: (isIncludeSection ? row - 1 : row), section: section)
    }
}


public enum DateFormatHit {
    case none
    case RFC822
    case RFC3339
}

public extension Date {
    
    static func internetDateTimeFormatter() -> DateFormatter {
        let locale = Locale(identifier: "en_US_POSIX")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }
    
    /// Get a date from a string - hint can be used to speed up
    static func dateFromInternet(dateString: String, format hint: DateFormatHit = .none) -> Date? {
        var date: Date?
        if hint != .RFC3339 {
            // try RFC822 first
            date = Date.dateFromRFC822(dateString: dateString)
            if date == nil {
                date = Date.dateFromRFC3339(dateString: dateString)
            }
        } else {
            //Try RFC3339 first
            date = Date.dateFromRFC3339(dateString: dateString)
            if (date == nil) {
                date = Date.dateFromRFC822(dateString: dateString)
            }
        }
        return date
    }
    
    // See http://www.faqs.org/rfcs/rfc822.html
    static func dateFromRFC822(dateString: String) -> Date? {
        var date: Date?
        let dateFormatter = Date.internetDateTimeFormatter()
        let RFC822String = dateString.uppercased()
        
        if (RFC822String.contains(",")) {
            if (date == nil) { // Sun, 19 May 2002 15:21:36 GMT
                dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // Sun, 19 May 2002 15:21 GMT
                dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm zzz"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // Sun, 19 May 2002 15:21:36
                dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // Sun, 19 May 2002 15:21
                dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm"
                date = dateFormatter.date(from: RFC822String)
            }
        } else {
            if (date == nil) { // 19 May 2002 15:21:36 GMT
                dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss zzz"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // 19 May 2002 15:21 GMT
                dateFormatter.dateFormat = "d MMM yyyy HH:mm zzz"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // 19 May 2002 15:21:36
                dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
                date = dateFormatter.date(from: RFC822String)
            }
            if (date == nil) { // 19 May 2002 15:21
                dateFormatter.dateFormat = "d MMM yyyy HH:mm"
                date = dateFormatter.date(from: RFC822String)
            }
        }
        return date
    }
    
    // See http://www.faqs.org/rfcs/rfc3339.html
    static func dateFromRFC3339(dateString: String) -> Date? {
        var date: Date?
        let dateFormatter = Date.internetDateTimeFormatter()
        var RFC3339String = dateString.uppercased()
        RFC3339String = RFC3339String.replacingOccurrences(of: "Z", with: "-0000")
        if (RFC3339String.count > 20) {
            RFC3339String = (RFC3339String as NSString).replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions(rawValue: 0), range: NSMakeRange(0, RFC3339String.count - 20)) as String
        }
        if (date == nil) { // 1996-12-19T16:39:57-0800
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
            date = dateFormatter.date(from: RFC3339String)
        }
        if (date == nil) { // 1937-01-01T12:00:27.87+0020
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"
            date = dateFormatter.date(from: RFC3339String)
        }
        if (date == nil) { // 1937-01-01T12:00:27
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
            date = dateFormatter.date(from: RFC3339String)
        }
        return date
    }
}


public extension UIButton {
    
    static func create(title: String?, fontSize: CGFloat = 14, normalColor: UIColor? = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: UIColor? = nil, backgroundImage: UIImage? = nil, backgroundColor: UIColor? = nil, moveTo superView: UIView? = nil, moreSetter: ((_ button: UIButton)->())? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        if let normalColor = normalColor {
            button.setTitleColor(normalColor, for: .normal)
        }
        button.setTitleColor(highlightedColor, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.backgroundColor = backgroundColor
        button.sizeToFit()
        superView?.addSubview(button)
        
        if let moreSetter = moreSetter {
            moreSetter(button)
        }
        
        return button
    }
    
    static func create(image: UIImage? = nil, highlightedImage: UIImage? = nil, backgroundImage: UIImage? = nil, backgroundHighlightedImage: UIImage? = nil, moveTo superView: UIView? = nil) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setBackgroundImage(backgroundHighlightedImage, for: .highlighted)
        superView?.addSubview(button)
        return button
    }
}


public extension UILabel {
    
    static func create(_ text: String, alignment: NSTextAlignment = .center, textColor: UIColor = .black, font size: CGFloat, lines: Int = 0, moveTo superView: UIView? = nil, moreSetter: ((_ label: UILabel)->())? = nil) -> UILabel {
        let label = UILabel()
        superView?.addSubview(label)
        label.text = text
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: size)
        label.numberOfLines = lines
        if let moreSetter = moreSetter {
            moreSetter(label)
        }
        return label
    }
}


public extension UIImageView {
    
    func setImage(_ image: UIImage, color: UIColor? = nil, contentMode: UIViewContentMode = .scaleAspectFit) {
        self.contentMode = contentMode
        if let color = color {
            self.image = image.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        } else {
            self.image = image
        }
    }
    
    func playGif(with imagePath: String) {
        guard imagePath.lowercased().hasSuffix(".gif"),
            let data = NSData(contentsOfFile: imagePath),
            let imageSource = CGImageSourceCreateWithData(data, nil) else {
                return
        }
        var gifImages = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            i == 0 ? self.image = image : ()
            gifImages.append(image)
            
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)
            let gifDict = unsafeBitCast(
                CFDictionaryGetValue(properties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
                to: CFDictionary.self) as Dictionary
            
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? Double else { continue }
            totalDuration += frameDuration
        }
        
        animationImages = gifImages
        animationDuration = totalDuration
        animationRepeatCount = 0
        startAnimating()
    }
}


public extension UIAlertController {
    
    static func present(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, cancel: String = "cancel", cancelHandler: ((UIAlertAction)->Void)? = nil, position: CGPoint? = nil, actions: [UIAlertAction], moreSetter: ((_ alert: UIAlertController)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: cancel.localized(), style: .cancel, handler: cancelHandler))
        alert.addActions(actions)
        
        if let moreSetter = moreSetter {
            moreSetter(alert)
        }
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        // iPad 需要指定，不然如果是 actionSheet 会崩溃
        alert.popoverPresentationController?.sourceView = rootViewController?.view
        if let position = position {
            alert.popoverPresentationController?.sourceRect = CGRect(origin: position, size: CGSize.zero)
        }
        
        DispatchQueue.main.async {
            rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach {
            addAction($0)
        }
    }
}


public extension UIScreen {
    
    static let portraitWidth = [UIScreen.width, UIScreen.height].min()!
    static let landscapeWidth = [UIScreen.width, UIScreen.height].max()!
    
    /// screen width
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// screen height
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public static func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

public extension UIDevice {
    
    /// 通过高度判断是否为 iPhone X
    static var isX: Bool {
        return [UIScreen.main.bounds.height, UIScreen.main.bounds.width].max() == 812
    }
}

public extension Bundle {
    
    static let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    static let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    static let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
}

