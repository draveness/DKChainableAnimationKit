//
//  DKChainableAnimationKit+Transform.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/5/23.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import UIKit

extension DKChainableAnimationKit {

    public var transformIdentity: DKChainableAnimationKit {
        get {
            self.addAnimationCalculationAction { (view: UIView) -> Void in
                let transformAnimation = self.basicAnimationForKeyPath("transform")
                let transform = CATransform3DIdentity
                transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
                transformAnimation.toValue = NSValue(caTransform3D: transform)
                self.addAnimationFromCalculationBlock(transformAnimation)
            }
            self.addAnimationCompletionAction { (view: UIView) -> Void in
                let transform = CATransform3DIdentity
                view.layer.transform = transform
            }
            return self
        }
    }

    public func transformX(_ x: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, x, 0, 0)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, x, 0, 0)
            view.layer.transform = transform
        }
        return self
    }

    public func transformY(_ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, 0, y, 0)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, 0, y, 0)
            view.layer.transform = transform
        }
        return self
    }

    public func transformZ(_ z: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, 0, 0, z)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, 0, 0, z)
            view.layer.transform = transform
        }
        return self
    }

    public func transformXY(_ x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, x, y, 0)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DTranslate(transform, x, y, 0)
            view.layer.transform = transform
        }
        return self
    }

    public func transformScale(_ scale: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, scale, scale, 1)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, scale, scale, 1)
            view.layer.transform = transform
        }
        return self
    }

    public func transformScaleX(_ scaleX: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, scaleX, 1, 1)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, scaleX, 1, 1)
            view.layer.transform = transform
        }
        return self
    }

    public func transformScaleY(_ scaleY: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let transformAnimation = self.basicAnimationForKeyPath("transform")
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, 1, scaleY, 1)
            transformAnimation.fromValue = NSValue(caTransform3D: view.layer.transform)
            transformAnimation.toValue = NSValue(caTransform3D: transform)
            self.addAnimationFromCalculationBlock(transformAnimation)
        }
        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var transform = view.layer.transform
            transform = CATransform3DScale(transform, 1, scaleY, 1)
            view.layer.transform = transform
        }
        return self
    }

    public func rotate(_ angle: Double) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let rotationAnimation = self.basicAnimationForKeyPath("transform.rotation")
            let transform = view.layer.transform
            let originalRotation = Double(atan2(transform.m12, transform.m11))
            rotationAnimation.fromValue = originalRotation as AnyObject!
            rotationAnimation.toValue = (originalRotation + self.degreesToRadians(angle)) as AnyObject!
            self.addAnimationFromCalculationBlock(rotationAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let transform = view.layer.transform
            let originalRotation = Double(atan2(transform.m12, transform.m11))
            let zRotation = CATransform3DMakeRotation(CGFloat(self.degreesToRadians(angle) + originalRotation), 0.0, 0.0, 1.0)
            view.layer.transform = zRotation
        }
        return self
    }

}
