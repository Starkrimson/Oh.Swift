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
        
//        label.attributedText = NSAttributedString.ex.attributedString(string: "Hello\n\(Date().addingTimeInterval(88640).ex.isInToday)", font: UIFont.boldSystemFont(ofSize: 50), color: .purple, attributes: [.paragraphStyle: paragraph])
        label.numberOfLines = 0

        registerDebug()
        label.center = view.center
        
        debugLog(Date().ex.string(.E))
        debugLog(Date().ex.string(.EEEE, ",", "yyyy"))
        
        title = Bundle.ex.displayName
        
        let dateFormats: [Extensions<Date>.DateFormats] = [.HHmm, "MMMMddyyyyHH:mm", "EEdd", "MMMddEE"]
        label.text = //[DateFormatter.Style.none, .short, .medium, .long, .full]
            dateFormats.reduce("") { (result, style) -> String in
            result + "\n" +
            ["zh_CN", "en_US", "ja_JP"].reduce("", { (result1, locale) -> String in
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = style
//                dateFormatter.locale = Locale(identifier: locale)
//                dateFormatter.setLocalizedDateFormatFromTemplate("dyMMMMHH:mmE") // // set template after setting locale
                
                let date = Date()
                let str = date.ex.string(style, "zzz", locale: locale)
                
                return result1 + "\n" + str//dateFormatter.string(from: Date().addingTimeInterval(86400 * 10))
            })
        }
        label.sizeToFit()
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
