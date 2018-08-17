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
            UIAlertController.ex.present(title: "go fuck", message: "yourself", preferredStyle: .actionSheet, cancel: "hell", cancelHandler: { (_) in
                print("ff")
            }, actions: [])
        }).disposed(by: rx.disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext:{
            UIAlertController.ex.alert(message: "Go fuck YOURSELF")
        }).disposed(by: rx.disposeBag)
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
