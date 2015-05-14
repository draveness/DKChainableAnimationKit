//
//  UIView+AnimationKit.swift
//  DKAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

private var animationKitAssociationKey = "animationKitAssociationKey"

public extension UIView {


    internal var animation: DKAnimationKit {
        get {
            var animation = objc_getAssociatedObject(self, &animationKitAssociationKey) as! DKAnimationKit?
            if let animation = animation {
                return animation
            } else {
                animation = DKAnimationKit()
                animation?.view = self
                objc_setAssociatedObject(self, &animationKitAssociationKey, animation, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
                return animation!
            }
        }
    }



}
