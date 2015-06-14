//
//  DKChainableAnimationKit+Bezier.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public extension DKChainableAnimationKit {

    public func moveOnPath(path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    public func moveAndRotateOnPath(path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            pathAnimation.rotationMode = kCAAnimationRotateAuto
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }

    public func moveAndReverseRotateOnPath(path: UIBezierPath) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let pathAnimation = self.basicAnimationForKeyPath("position")
            pathAnimation.path = path.CGPath
            pathAnimation.rotationMode = kCAAnimationRotateAutoReverse
            self.addAnimationFromCalculationBlock(pathAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let endPoint = path.currentPoint
            view.layer.position = endPoint
        }
        return self
    }
}