//
//  ViewController.swift
//  Oh.Swift
//
//  Created by Starkrimson on 12/09/2021.
//  Copyright (c) 2021 Starkrimson. All rights reserved.
//

import UIKit
import OhSwift

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.oh.register(UITableViewCell.self)
        return tableView
    }()

    var dataSource: [(sectionTitle: String, items: [String])] = [
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
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Oh.Swift"

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataSource[section].sectionTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.oh.dequeue(UITableViewCell.self)
        let item = dataSource[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
}
