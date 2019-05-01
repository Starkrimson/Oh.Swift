
public struct Extensions<Base> {
    internal let base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionsCompatible {
    associatedtype ExtensionsCompatibleType
    static var ex: Extensions<ExtensionsCompatibleType>.Type { get set }
    var ex: Extensions<ExtensionsCompatibleType> { get set }
}

extension ExtensionsCompatible {
    public static var ex: Extensions<Self>.Type {
        get {
            return Extensions<Self>.self
        }
        set {
            
        }
    }
    
    public var ex: Extensions<Self> {
        get {
            return Extensions(self)
        }
        set {
            
        }
    }
}

extension NSObject: ExtensionsCompatible { }

public extension Extensions where Base: NSObject {
    
}

public extension Extensions where Base: UIColor {
    
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
        return UIColor.ex.rgb(r: arc4random_uniform(256), g: arc4random_uniform(256), b: arc4random_uniform(256))
    }
    
    /// 返回 UIColor 的颜色数值，0 ~ 1。
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let ciColor = CIColor(cgColor: base.cgColor)
        return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
    }

    static func hex(_ hex: UInt32) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor.ex.rgb(r: r, g: g, b: b)
    }
    
    static func rgb(r: UInt32, g: UInt32, b: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    static func white(_ white: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(white: CGFloat(white)/255.0, alpha: alpha)
    }
}

public extension Extensions where Base: UIImage {
    
    /// 绘制圆角图片
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - size: image size default self.size
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    /// - Returns: 圆角图片
    func cornerRadius(_ cornerRadius: CGFloat, size: CGSize = .zero, borderWidth: CGFloat = 0, borderColor: UIColor = .white) -> UIImage {
        // make a CGRect with the image's size
        let rect = CGRect(origin: .zero, size: size == .zero ? base.size : size)
        
        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        // create a UIBezierPath
        let roundedPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        // clip to the roundedPath
        roundedPath.addClip()
        
        UIColor.white.set()
        roundedPath.fill()
        
        // draw the image in the rect *AFTER* the context is clipped
        base.draw(in: rect)
        
        // create a border
        if borderWidth > 0 {
            roundedPath.lineWidth = borderWidth;
            borderColor.set()
            roundedPath.stroke()
        }
        
        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext();
        
        return roundedImage ?? base
    }
    
    /// 绘制圆形图片
    ///
    /// - Parameters:
    ///   - size: 图片 size default self.siae
    ///   - borderWidth: 边框宽
    ///   - borderColor: 边框颜色
    /// - Returns: 圆形图片
    func circular(size: CGSize = .zero, borderWidth: CGFloat = 0, borderColor: UIColor = .white) -> UIImage {
        let rect = CGRect(origin: .zero, size: size == .zero ? base.size : size)
        return base.ex.cornerRadius(rect.size.width, size: rect.size, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    /// 绘制图片
    func draw(size: CGSize = .zero, backgroundColor: UIColor = UIColor.white) -> UIImage? {
        let size = size == .zero ? base.size : size
        let rect = CGRect(origin: CGPoint(), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backgroundColor.setFill()
        UIRectFill(rect)
        
        base.draw(in: rect)
        
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

public extension Extensions where Base: NSAttributedString {
    
    static func attributedString(string: String?, fontSize size: CGFloat, color: UIColor?) -> NSAttributedString? {
        guard let string = string else { return nil }
        
        let attributes = [NSAttributedString.Key.foregroundColor: color ?? UIColor.black,
                          .font: UIFont.systemFont(ofSize: size)]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
    static func attributedString(string: String?, font: UIFont, color: UIColor?, attributes: [NSAttributedString.Key : Any] = [:]) -> NSAttributedString? {
        guard let string = string else { return nil }
        
        var attributes = attributes
        attributes[.foregroundColor] = color ?? UIColor.black
        attributes[.font] = font
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
}

extension CGPoint: ExtensionsCompatible { }
public extension Extensions where Base == CGPoint {
    
    var commitTranslation: UISwipeGestureRecognizer.Direction? {
        let absX = abs(base.x)
        let absY = abs(base.y)
        
        guard absX + absY > 0.0 else {
            return nil
        }
        
        if absX > absY {
            if base.x < 0 {
                return .left
            }else{
                return .right
            }
            
        } else if absY > absX {
            if base.y < 0 {
                return .up
            }else{
                return .down
            }
        }
        return nil
    }
}

extension URL: ExtensionsCompatible { }
public extension Extensions where Base == URL {
    func copyItem(to dstURL: URL) {
        try? FileManager.default.copyItem(at: base, to: dstURL)
    }
}

extension String: ExtensionsCompatible {
   
    /// 路径拼接
    ///
    /// - Parameters:
    ///   - lhs: 原路径
    ///   - rhs: 文件夹或者文件名
    /// - Returns: 新路径
    /// eg. "/Doc"/"folder"/"fileName.md" --> "/Doc/folder/fileName.md"
    public static func /(lhs: String, rhs: String) -> String {
        return lhs + "/" + rhs
    }
}

public extension Extensions where Base == String {
    
    var isUrlSupported: Bool {
        return base.hasPrefix("http://") || base.hasPrefix("https://")
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(margin: CGFloat, fontSize: CGFloat) -> CGFloat {
        return heightWithConstrainedWidth(width: UIScreen.ex.width - margin, font: UIFont.systemFont(ofSize: fontSize))
    }
    
    func copyItem(toPath dstPath: String) {
        try? FileManager.default.copyItem(atPath: base, toPath: dstPath)
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(base, comment: "Localizable"), arguments: arguments)
    }
    
    var encode: String? {
        let characterSet = NSCharacterSet(charactersIn: "!*'\\\\\"();:@&=+$,/?%#[]% ")
        return base.contains("/") ? base.addingPercentEncoding(withAllowedCharacters: characterSet.inverted) : base
    }
    
    var decode: String? {
        return base.removingPercentEncoding
    }
    
    /// 计算当前 option 在 options 内的 index
    ///
    /// - Parameter options: 选项列表
    /// - Returns: indexPath
    func calculateIndexPath(in options: [[String]], isIncludeSection: Bool = false) -> IndexPath? {
        let sectionOfOptions = options.filter { (arr) -> Bool in
            arr.contains(base)
        }
        guard let sectionValue = sectionOfOptions.first,
            let section = options.firstIndex(where: {$0 == sectionValue}),
            let row = sectionValue.firstIndex(where: {$0 == base})
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

extension Date: ExtensionsCompatible { }
public extension Extensions where Base == Date {
    
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
            date = Date.ex.dateFromRFC822(dateString: dateString)
            if date == nil {
                date = Date.ex.dateFromRFC3339(dateString: dateString)
            }
        } else {
            //Try RFC3339 first
            date = Date.ex.dateFromRFC3339(dateString: dateString)
            if (date == nil) {
                date = Date.ex.dateFromRFC822(dateString: dateString)
            }
        }
        return date
    }
    
    // See http://www.faqs.org/rfcs/rfc822.html
    static func dateFromRFC822(dateString: String) -> Date? {
        var date: Date?
        let dateFormatter = Date.ex.internetDateTimeFormatter()
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
        let dateFormatter = Date.ex.internetDateTimeFormatter()
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
    
    struct DateFormats: ExpressibleByStringLiteral {

        let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            rawValue = value
        }
        
        /// 12:34
        public static let HHmm: DateFormats = "HH:mm"
        /// January
        public static let MMMM: DateFormats = "MMMM"
        /// Jan
        public static let MMM: DateFormats = "MMM"
        /// 2019
        public static let yyyy: DateFormats = "yyyy"
        /// 09
        public static let dd: DateFormats = "dd"
        /// Tuesday
        public static let EEEE: DateFormats = "EEEE"
        /// Tue
        public static let E: DateFormats = "E"
    }
    
    func string(_ localizedDateFormatFromTemplates: DateFormats..., locale identifier: String? = Locale.preferredLanguages.first) -> String {
        let dateFormatter = DateFormatter()
        let template = localizedDateFormatFromTemplates.reduce(into: "") { $0 += $1.rawValue }
        dateFormatter.locale = Locale(identifier: identifier ?? "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate(template)
        return dateFormatter.string(from: base)
    }
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(base)
    }
    
    @available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    var isInThisWeek: Bool {
        guard let dateInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: Date()) else { return false }
        return dateInterval.contains(base)
    }
}

public extension Extensions where Base: UIButton {
    
    static func create(title: String?, fontSize: CGFloat = 14, normalColor: UIColor? = .black, highlightedColor: UIColor? = nil, backgroundImage: UIImage? = nil, backgroundColor: UIColor? = nil, moveTo superView: UIView? = nil, moreSetter: ((_ button: UIButton)->())? = nil) -> UIButton {
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

public extension Extensions where Base: UILabel {
    
    static func create(_ text: String, alignment: NSTextAlignment = .center, textColor: UIColor = .black, font: UIFont, lines: Int = 0, moveTo superView: UIView? = nil, moreSetter: ((_ label: UILabel)->())? = nil) -> UILabel {
        let label = UILabel()
        superView?.addSubview(label)
        label.text = text
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = font
        label.numberOfLines = lines
        if let moreSetter = moreSetter {
            moreSetter(label)
        }
        return label
    }
    
    static func create(_ text: String, alignment: NSTextAlignment = .center, textColor: UIColor = .black, font size: CGFloat, lines: Int = 0, moveTo superView: UIView? = nil, moreSetter: ((_ label: UILabel)->())? = nil) -> UILabel {
        return UILabel.ex.create(text, alignment: alignment, textColor: textColor, font: UIFont.systemFont(ofSize: size), lines: lines, moveTo: superView,  moreSetter: moreSetter)
    }
}

public extension Extensions where Base: UIImageView {
    
    func setImage(_ image: UIImage, color: UIColor? = nil, contentMode: UIView.ContentMode = .scaleAspectFit) {
        base.contentMode = contentMode
        if let color = color {
            base.image = image.withRenderingMode(.alwaysTemplate)
            base.tintColor = color
        } else {
            base.image = image
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
            i == 0 ? base.image = image : ()
            gifImages.append(image)
            
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)
            let gifDict = unsafeBitCast(
                CFDictionaryGetValue(properties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
                to: CFDictionary.self) as Dictionary
            
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? Double else { continue }
            totalDuration += frameDuration
        }
        
        base.animationImages = gifImages
        base.animationDuration = totalDuration
        base.animationRepeatCount = 0
        base.startAnimating()
    }
}

public extension Extensions where Base: UIAlertController {
    
    static func present(title: String?, message: String?, preferredStyle: UIAlertController.Style, cancel: String = "cancel", cancelHandler: ((UIAlertAction)->Void)? = nil, position: CGPoint? = nil, actions: [UIAlertAction], moreSetter: ((_ alert: UIAlertController)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let bundleURL = Bundle.main.privateFrameworksURL?.appendingPathComponent("Extensions.framework").appendingPathComponent("Localization.bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(cancel, bundle: bundle, comment: "Localizable"), style: .cancel, handler: cancelHandler))
        alert.ex.addActions(actions)
        
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
        actions.forEach(base.addAction)
    }
    
    static func debugAlert(_ message: String) {
        #if DEBUG
        UIAlertController.ex.present(title: "Debug", message: message, preferredStyle: .alert, cancel: "confirm", actions: [])
        #endif
    }
    
    static func alert(title: String = "Error", message: String) {
        UIAlertController.ex.present(title: title, message: message, preferredStyle: .alert, cancel: "confirm", actions: [])
    }
}

public extension Extensions where Base: UIScreen {
    
    static var portraitWidth: CGFloat {
        return [UIScreen.ex.width, UIScreen.ex.height].min()!
    }
    
    static var landscapeWidth: CGFloat {
        return [UIScreen.ex.width, UIScreen.ex.height].max()!
    }
    
    /// screen width
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// screen height
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

public extension Extensions where Base: Bundle {
    
    static var displayName: String {
        return Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
                ?? Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
                ?? ""
    }
    static var marketingVersion: String { return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
    static var buildVersion: String { return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "" }
    
    static var documentDirectory: String { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] }
}

public extension Extensions where Base: UIApplication {
    
    static func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsURL)
        }
    }
}

extension Sequence where Element: Hashable {
    
    /// Removing duplicate elements and keep origin order
    ///
    /// - Returns: [Element]
    func unique() -> [Element] {
        var seen: Set<Element> = []
        return filter({ (element) -> Bool in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        })
    }
}
