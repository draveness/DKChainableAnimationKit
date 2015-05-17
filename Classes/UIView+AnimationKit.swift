//
//  UIView+AnimationKit.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

private var animationKitAssociationKey = "animationKitAssociationKey"

public extension UIView {

    final public var animation: DKChainableAnimationKit {
        get {
            var animation: DKChainableAnimationKit! = objc_getAssociatedObject(self, &animationKitAssociationKey) as? DKChainableAnimationKit
            if let animation = animation {
                return animation
            } else {
                animation = DKChainableAnimationKit()
                animation.view = self
                objc_setAssociatedObject(self, &animationKitAssociationKey, animation, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
                return animation
            }
        }
    }

    final public func bezierPathForAnimation() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(self.layer.position)
        return path
    }

}
