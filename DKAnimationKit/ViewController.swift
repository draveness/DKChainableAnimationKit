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
//        v.animation.moveX(50).easeIn.thenAfter(1.0).makeScale(2.0).thenAfter(1.0).moveXY(20, 20).animate(1.0)
        let purple = UIColor.purpleColor()
        v.animation.makeBackground(purple).animate(1.0);
        v.animation.animationCompletion = {
            self.v.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            self.v.frame = CGRectMake(100, 150, 50, 50);
            self.v.animation.makeOpacity(1.0).makeBackground(UIColor.blueColor()).animate(1.0);

            sender.animation.moveY(-50).easeInOutExpo.animate(1.1).animationCompletion = {
                sender.userInteractionEnabled = true;
            };
        }

        sender.animation.moveY(50).easeInOutExpo.animate(0.5);

    }
}

