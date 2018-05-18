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
        print(UIDevice.isX)
        
        DispatchQueue.once(token: "onec") {
            
        }
    
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIAlertController.present(title: "hehe", message: "xixi", preferredStyle: .actionSheet, actions: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
