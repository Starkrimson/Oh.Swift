public struct Extensions<Base> {
    internal let base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}

public protocol ExtensionsCompatible {
    associatedtype CompatibleType
    static var ex: Extensions<CompatibleType>.Type { get set }
    var ex: Extensions<CompatibleType> { get set }
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

extension UIColor: ExtensionsCompatible { }
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

extension UIImage: ExtensionsCompatible { }
public extension Extensions where Base: UIImage {
    
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
        base.draw(in: circleRect)
        
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
        
        return roundedImage ?? base
    }
    
    func create(size: CGSize? = nil, backgroundColor: UIColor = UIColor.white) -> UIImage? {
        var size = size
        if size == nil {
            size = base.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
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

extension NSAttributedString: ExtensionsCompatible { }
public extension Extensions where Base: NSAttributedString {
    
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

extension CGPoint: ExtensionsCompatible { }
public extension Extensions where Base == CGPoint {
    
    var commitTranslation: UISwipeGestureRecognizerDirection? {
        let absX = fabs(base.x)
        let absY = fabs(base.y)
        
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
    static func /(lhs: String, rhs: String) -> String {
        return lhs + "/" + rhs
    }
}

public extension Extensions where Base == String {
    
    var isUrlSupported: Bool {
        return base.hasPrefix("http://") || base.hasPrefix("https://")
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
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
            let section = options.index(where: {$0 == sectionValue}),
            let row = sectionValue.index(where: {$0 == base})
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
}

extension UIButton: ExtensionsCompatible { }
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

extension UILabel: ExtensionsCompatible { }
public extension Extensions where Base: UILabel {
    
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

extension UIImageView: ExtensionsCompatible { }
public extension Extensions where Base: UIImageView {
    
    func setImage(_ image: UIImage, color: UIColor? = nil, contentMode: UIViewContentMode = .scaleAspectFit) {
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

extension UIAlertController: ExtensionsCompatible { }
public extension Extensions where Base: UIAlertController {
    
    static func present(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, cancel: String = "cancel", cancelHandler: ((UIAlertAction)->Void)? = nil, position: CGPoint? = nil, actions: [UIAlertAction], moreSetter: ((_ alert: UIAlertController)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: cancel.ex.localized(), style: .cancel, handler: cancelHandler))
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
        actions.forEach {
            base.addAction($0)
        }
    }
}

extension UIScreen: ExtensionsCompatible { }
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

extension UIDevice: ExtensionsCompatible { }
public extension Extensions where Base: UIDevice {
    
    /// 通过高度判断是否为 iPhone X
    static var isX: Bool {
        return [UIScreen.main.bounds.height, UIScreen.main.bounds.width].max() == 812
    }
}

extension Bundle: ExtensionsCompatible { }
public extension Extensions where Base: Bundle {
    
    static var displayName: String { return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "" }
    static var versionString: String { return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
    static var buildVersion: String { return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "" }
    
    static var documentDirectory: String { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] }
}

