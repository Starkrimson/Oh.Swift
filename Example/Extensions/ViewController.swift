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
    
    let textlabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext:{
            UIAlertController.ex.present(title: "open Settings", message: nil, preferredStyle: .actionSheet, cancel: "hell", cancelHandler: { (_) in
                UIApplication.ex.openSettings()
            }, actions: [])
        }).disposed(by: rx.disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext:{
            UIAlertController.ex.alert(message: "Go fuck YOURSELF")
        }).disposed(by: rx.disposeBag)
           
        let label = UILabel()//(frame: CGRect(x: 20, y: 200, width: 300, height: 100))
        view.addSubview(label)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .left
        paragraph.lineBreakMode = .byTruncatingTail
        
        label.attributedText = NSAttributedString.ex.attributedString(string: "Hello", font: UIFont.boldSystemFont(ofSize: 50), color: .purple, attributes: [.paragraphStyle: paragraph])
        
        registerDebug()
        if #available(iOS 11.0, *) {
            label.backgroundColor = .yellow
            label.ex.makeSafeAreaContraints(offset: .init(top: 50, left: 50, bottom: 50, right: 50))
        } else {
            // Fallback on earlier versions
        }
        
        debugLog("hello")
        debugLog([1, 2, 3])
        debugLog(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIAlertController.ex.debugAlert("hehe")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class Textview: UIView, UITextFieldDelegate {
    
    let textField = UITextField()
    
    let onConfirmInput = Delegate<String?, Void>()
    private func confirmButtonPressed() {
        onConfirmInput.call(textField.text)
    }
    
    let onTapAbort = Delegate<Void, Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        textField.frame = CGRect(x: 20, y: 20, width: 300, height: 40)
        textField.backgroundColor = .gray
        textField.clearButtonMode = .always
        textField.delegate = self
//        textField.rx.controlEvent(.editingChanged).subscribe(onNext: { (_) in
//            self.confirmButtonPressed()
//        }).disposed(by: rx.disposeBag)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onTapAbort.call()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
