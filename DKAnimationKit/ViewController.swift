//
//  ViewController.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let v: UIView = UIView(frame: CGRect(x: 100, y: 150, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        v.backgroundColor = UIColor.blueColor()
        view.addSubview(v)


        let button = UIButton(frame: CGRect(x: 100, y: 150, width: 50, height: 50))
        button.frame = CGRect(x: 0, y: self.view.bounds.size.height - 50.0, width: self.view.bounds.size.width, height: 50)
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Action!", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "animateView:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }

    func animateView(sender: UIButton) {
        v.animation.makeOpacity(0.5).thenAfter(1.0).makeSize(200, 200).animate(1)
    }
}

