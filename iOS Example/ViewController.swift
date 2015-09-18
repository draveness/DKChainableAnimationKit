//
//  ViewController.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/5/13.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

class ViewController: UIViewController {

    let v: UIView = UIView(frame: CGRect(x: 100, y: 150, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()

        v.backgroundColor = UIColor.blueColor()
        self.view.addSubview(v)

        UIApplication.sharedApplication().statusBarHidden = true

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.frame = CGRect(x: 0, y: self.view.bounds.size.height - 50.0, width: self.view.bounds.size.width, height: 50)
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("Action!", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "animateView:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }

    func animateView(sender: UIButton) {
        sender.userInteractionEnabled = false
        _ = UIColor.purpleColor()
        let green = UIColor.greenColor()

        v.animation.moveX(100).thenAfter(1.0).moveWidth(50).bounce.makeBackground(green).easeIn.anchorTopLeft.thenAfter(0.5).rotate(95).easeBack.thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animateWithCompletion(0.4, {
            self.v.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
            self.v.frame = CGRectMake(100, 150, 50, 50)
            self.v.animation.makeOpacity(1.0).makeBackground(UIColor.blueColor()).animate(1.0)
            self.v.layer.cornerRadius = 0


            sender.animation.moveY(-50).easeInOutExpo.animate(1.1).animationCompletion = {
                sender.userInteractionEnabled = true
            };
        })

        sender.animation.moveY(50).easeInOutExpo.animate(0.5)

    }
}

