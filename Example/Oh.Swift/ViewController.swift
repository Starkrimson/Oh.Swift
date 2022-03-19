//
//  ViewController.swift
//  Oh.Swift
//
//  Created by Starkrimson on 12/09/2021.
//  Copyright (c) 2021 Starkrimson. All rights reserved.
//

import UIKit
import OhSwift
import RxSwift

struct Model: Codable {
    @Default<String> var text: String
    @Default<Int> var integer: Int
    @Default<Double> var decimal: Double
    @Default.True var flag: Bool
}

class ViewController: UIViewController {

    lazy var tableView = UITableView.oh.new {
        $0.rawValue.oh.register(UITableViewCell.self)
    }

    lazy var dataSource: [(sectionTitle: String, items: [String])] = [
        ("Bundle", [
            "Display name: \(Bundle.oh.displayName)",
            "Version: \(Bundle.oh.marketingVersion)",
            "Build number: \(Bundle.oh.buildVersion)",
        ]),
        ("UIColor", [
            "白 \(UIColor.oh.hex(0xFFFFFF))",
            "黑 \(UIColor.black.oh.components)",
            "随机 \(UIColor.oh.random)"
        ]),
        ("UIScreen", [
            "宽 \(UIScreen.oh.portraitWidth)",
            "高 \(UIScreen.oh.landscapeWidth)",
            "Size \(CGSize(width: .oh.screenWidth, height: .oh.screenHeight))"
        ]),
        ("UserDefaultsWrapper", [
            // UserDefaults.standard.bool(forKey: "oh.swift.toggle")
            "toggle \(toggle!)"
        ])
    ]

    @UserDefaultsWrapper("oh.swift.toggle", defaultValue: true)
    var toggle: Bool!

    @FileStorage(directory: .documentDirectory, fileName: "file.txt")
    var file: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = .oh.appName

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }

        // UserDefaults.standard.set(false, forKey: "oh.swift.toggle")
        // UserDefaults.standard.synchronize()
        toggle = false

        let jsonString = """
                         {
                            "text1": "hello world!",
                            "integer": 99,
                            "decimal": 66
                         }
                         """
        do {
            let model = try JSONDecoder().decode(Model.self, from: jsonString.data(using: .utf8)!)
            print(model) // text = "", integer = 99, decimal = 66.0, flag = true
        } catch {
            print(error.localizedDescription)
        }

        NotificationCenter.default.rx
            .notification(.aNotificationName)
            .subscribe(onNext: { notification in
                let str = notification.oh.getUserInfo(for: .aUserInfoKey) // str: String
                print(str)
            })
            .disposed(by: rx.disposeBag)

        Observable.just(dataSource.map { $0.items }.flatMap { $0 } )
            .bind(to: tableView.rx.items(cell: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element
            }
            .disposed(by: rx.disposeBag)

        tableView.rx.modelSelectedAtIndexPath(String.self)
            .subscribe(onNext: { (element, indexPath) in
                NotificationCenter.oh.post(name: .aNotificationName, typedUserInfo: [
                    .aUserInfoKey: "\(indexPath) - \(element)"
                ])
            })
            .disposed(by: rx.disposeBag)

        let testView = UIView.oh.new { make in
            make.background(color: .white)
                .border(width: 10)
                .corner(radius: 20)

            if #available(iOS 11.0, *) {
                make.corner(radius: 20, corners: [.topLeft, .bottomRight])
            }

            make.rawValue.frame = .init(x: 50, y: 650, width: 100, height: 100)
        }
        view.addSubview(testView)

        let label = UILabel(frame: .init(x: 160, y: 650, width: 100, height: 100))
            .oh.modifier
            .superView(view)
            .text("Bonjour，tristesse！")
            .textColor(.blue)
            .font(ofSize: 18)
            .background(color: .oh.random)
            .border()
            .corner(radius: 20)
            .isHidden(false)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth(true)
            .numberOfLines(3)

        let button = UIButton(frame: .init(x: 310, y: 650, width: 100, height: 100))
            .oh.modifier
            .superView(view)
            .title("Button")
            .titleColor(.oh.random)
            .font(ofSize: 20, weight: .semibold)

        button.rawValue.rx.tap
            .subscribe(onNext: {
                label.toggleHidden()
            })
            .disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Notification.Name {
    static let aNotificationName = Notification.Name("aNotificationName")
}

extension UserInfoKey {

    static var aUserInfoKey: UserInfoKey<String> {
        .init(key: "aUserInfoKey")
    }
}
