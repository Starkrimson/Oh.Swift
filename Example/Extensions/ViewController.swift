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
        NotificationCenter.default.addObserver(self, selector: #selector(aNotificationReceived(sender:)), name: .aNotificationName, object: nil)
        
        let tableView = UITableView()

         Observable.just([])
            .bind(to: tableView.rx.items(cell: UITableViewCell.self)) { (row,element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: rx.disposeBag)

        tableView.ex.register(UITableViewCell.self)
        _ = tableView.ex.dequeue(UITableViewCell.self)
        _ = ViewController.ex.instantiate()
    }
    
    @objc func aNotificationReceived(sender: Notification) {
        let s = sender.ex.getUserInfo(for: .aUserInfoKey)
        po(s, style: .warning)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.ex.post(name: .aNotificationName,
                                           typedUserInfo: [.aUserInfoKey: "hello"])
        NotificationCenter.ex.post(name: .aNotificationName,
                                   typedUserInfo: [.aUserInfoKey: "hello ex"])
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

extension Notification.Name {
    static let aNotificationName = Notification.Name("aNotificationName")
}

extension Extensions.UserInfoKey {
    static var aUserInfoKey: Extensions.UserInfoKey<String> {
        return.init(key: "aUserInfoKey")
    }
    static var eventStoreChangedChangeBehaviorKey: Extensions.UserInfoKey<String> {
        return Extensions.UserInfoKey(key: "Montreal.app.EventStoreChangedNotification.ChangeBehavior")
    }

}
