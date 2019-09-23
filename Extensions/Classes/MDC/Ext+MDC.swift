import MaterialComponents

public extension Extensions where Base: NSObject {
    
    typealias SnackAction = (title: String, handler: ()->())
    @available(*, deprecated, message: "Please use `public func snack` as a replacement.")
    func snack(text: String, style: POStyle = .normal, action: SnackAction? = nil, completionHandler: ((Bool) -> ())? = nil) {
        let msg = style == .normal ? text : "\(style.rawValue) \(text)"
        let message = MDCSnackbarMessage(text: msg)
        let messageAction = MDCSnackbarMessageAction()
        messageAction.title = action?.title
        messageAction.handler = action?.handler
        message.action = messageAction
        MDCSnackbarManager.setButtonTitleColor(UIColor.ex.hex(0x7BBD5D), for: .normal)
        
        message.completionHandler = completionHandler
        
        DispatchQueue.main.async {
            MDCSnackbarManager.show(message)
        }
        po(msg, id: "Snack")
    }
}

public typealias SnackAction = (title: String, handler: ()->())

public func snack(text: String, style: POStyle = .normal, action: SnackAction? = nil, completionHandler: ((Bool) -> ())? = nil) {
    let msg = style == .normal ? text : "\(style.rawValue) \(text)"
    let message = MDCSnackbarMessage(text: msg)
    let messageAction = MDCSnackbarMessageAction()
    messageAction.title = action?.title
    messageAction.handler = action?.handler
    message.action = messageAction
    MDCSnackbarManager.setButtonTitleColor(UIColor.ex.hex(0x7BBD5D), for: .normal)
    
    message.completionHandler = completionHandler
    
    DispatchQueue.main.async {
        MDCSnackbarManager.show(message)
    }
    po(msg, id: "Snack")
}
