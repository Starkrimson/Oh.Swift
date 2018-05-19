//
//  ViewController.swift
//  Extensions
//
//  Created by Xujx on 05/18/2018.
//  Copyright (c) 2018 Xujx. All rights reserved.
//

import UIKit
import Extensions

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIDevice.ex.isX)
        
        view.backgroundColor = UIColor.ex.hex(0x666666)
        
        let img = #imageLiteral(resourceName: "NFSNL").ex.makeCircularImage(size: CGSize(width: 300, height: 300), borderWidth: 5)
        let img1 = #imageLiteral(resourceName: "NFSNL").ex.create()
        let screenshot = UIImage.ex.screenshot(of: view)
        let imgView = UIImageView(image: #imageLiteral(resourceName: "NFSNL"))
        imgView.ex.setImage(img)
        imgView.frame = CGRect(x: 20, y: 20, width: 300, height: 300)
        view.addSubview(imgView)
        let arr = [img, img1, screenshot]
        let label = UILabel.ex.create("wrold", font: 20)
        label.frame = CGRect(x: 20, y: 20, width: 100, height: 40)
//        label.attributedText = NSAttributedString.ex.attributedString(string: "hello", font: UIFont.systemFont(ofSize: 20), color: .yellow)
        view.addSubview(label)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        let date = Date.ex.dateFromRFC822(dateString: "Sun, 19 May 2002 15:21:36 GMT")
        let date1 = Date.ex.dateFromRFC3339(dateString: "1996-12-19T16:39:57-0800")
        let width = UIScreen.ex.portraitWidth
        print(date)
    }
    
    @objc func panAction(sender: UIPanGestureRecognizer) {
//        let direction = sender.location(in: view).ex.commitTranslation
//        print(direction)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let direction = pan.translation(in: view).ex.commitTranslation
        return direction == .right
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIAlertController.ex.present(title: "hehe", message: "xixi", preferredStyle: .actionSheet, actions: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
