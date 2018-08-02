//
//  ViewController.swift
//  Extensions
//
//  Created by Xujx on 05/18/2018.
//  Copyright (c) 2018 Xujx. All rights reserved.
//

import UIKit
import Extensions

class ViewController: UIViewController {
    
    let textlabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel.ex.create("xixi", font: UIFont.boldSystemFont(ofSize: 30))
        view.addSubview(label)
        label.center = view.center
        label.sizeToFit()
        
        _ = UILabel.ex.create("hehe", font: 20) { label in
            self.view.addSubview(label)
            label.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
        }
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "NFSNL").ex.draw())
        imageView.frame = CGRect(x: 20, y: 20, width: 300, height: 300)
        view.addSubview(imageView)
        
        let inputView = Textview(frame: CGRect(x: 20, y: 420, width: UIScreen.ex.width, height: 100))
        inputView.onTapAbort.delegate(on: self) { (self, _) in
            label.text = "clear"
            self.textlabel.text = "clear"
        }
        view.addSubview(inputView)
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
