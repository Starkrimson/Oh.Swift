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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        ex.po("123", "po", "abc")
        ex.po("123", "po", "abc", id: "debug", style: .warning)
        ex.po("123", "po", "abc", id: "po", style: .error)
        ex.po("abc", self, id: "hehe")
        
        debugLog("hello")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let str = Date().ex.string(.yyyy)
        let str2 = Date().ex.string(.EEEE, .MMMM, .yyyy)
        let date = Date()
        let str3 = date.ex.string(.EEEE, .dd, .MMMM)
        let str4 = date.ex.string(.dd, .MMMM, "E")

        UIAlertController.ex.debugAlert([str, str2, str3, str4, Locale.current.identifier, Locale.preferredLanguages[0]].reduce("", { $0 + "\n" + $1 }))
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
