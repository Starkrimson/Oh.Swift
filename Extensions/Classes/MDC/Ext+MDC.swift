import MaterialComponents

public extension Extensions where Base: NSObject {
    
    typealias Action = (title: String, handler: ()->())
    func snack(text: String, action: Action? = nil) {
        DispatchQueue.main.async {
            let message = MDCSnackbarMessage(text: text)
            let messageAction = MDCSnackbarMessageAction()
            messageAction.title = action?.title
            messageAction.handler = action?.handler
            message.action = messageAction
            MDCSnackbarManager.setButtonTitleColor(UIColor.ex.hex(0x7BBD5D), for: .normal)
            MDCSnackbarManager.show(message)
        }
        po(text, id: "Snack")
    }
}
