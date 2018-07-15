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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIAlertController.ex.debugAlert("hehe")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
