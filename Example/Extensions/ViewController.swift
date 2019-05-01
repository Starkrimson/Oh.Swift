//
//  ViewController.swift
//  Extensions
//
//  Created by Xujx on 05/18/2018.
//  Copyright (c) 2018 Xujx. All rights reserved.
//

import UIKit
import Extensions
import RxSwift
import MaterialComponents

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.snack(text: "copyright", style: .normal, action: ("点我", {
                self.ex.po("tapped")
            })) { _ in
                self.ex.po("completed")
            }
        }
    }
    
    typealias SnackAction = (title: String, handler: ()->())
    func snack(text: String, style: Extensions<NSObject>.POStyle = .normal, action: SnackAction? = nil, completionHandler: ((Bool) -> ())? = nil) {
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
        ex.po(msg, id: "Snack")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: DebuggableContext {
    
    var debugMenus: [DebuggableContextItem] {
        return [
            DebuggableContextItem(name: "Color to Cupid", action: { [weak self] in
                self?.view.backgroundColor = UIColor(red:0.94, green:0.73, blue:0.83, alpha:1.00)
            }),
            .init(name: "Color To Mint") { [weak self] in
                self?.view.backgroundColor = UIColor(red:0.71, green:0.96, blue:0.82, alpha:1.00)
            }
        ]
    }
}
