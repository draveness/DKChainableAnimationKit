//
//  DKChainableAnimationKit+Frame.swift
//  DKChainableAnimationKit
//
//  Created by Draveness on 15/6/14.
//  Copyright (c) 2015年 Draveness. All rights reserved.
//

import Foundation

public extension DKChainableAnimationKit {

    public func makeFrame(_ rect: CGRect) -> DKChainableAnimationKit {
        return self.makeOrigin(rect.origin.x, rect.origin.y).makeBounds(rect)
    }

    public func makeFrame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return self.makeOrigin(x, y).makeBounds(rect)
    }

    public func makeBounds(_ rect: CGRect) -> DKChainableAnimationKit {
        return self.makeSize(rect.size.width, rect.size.height)
    }

    public func makeBounds(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(width, height)
    }


    public func makeSize(_ width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {

        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let sizeAnimation = self.basicAnimationForKeyPath("bounds.size")
            sizeAnimation.fromValue = NSValue(cgSize: view.layer.bounds.size)
            sizeAnimation.toValue = NSValue(cgSize: CGSize(width: width, height: height))
            self.addAnimationFromCalculationBlock(sizeAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let bounds = CGRect(x: 0, y: 0, width: width, height: height)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func makeOrigin(_ x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(cgPoint: view.layer.position)
            positionAnimation.toValue = NSValue(cgPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            view.layer.position = newPosition
        }
        return self

    }

    public func makeCenter(_ x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newCenter: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(cgPoint: view.layer.position)
            positionAnimation.toValue = NSValue(cgPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.center = CGPoint(x: x, y: y)
        }
        return self
    }

    public func makeX(_ x: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            positionAnimation.fromValue = view.layer.position.x as AnyObject!
            positionAnimation.toValue = newPosition.x as AnyObject!
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            view.layer.position = newPosition
        }
        return self
    }

    public func makeY(_ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            positionAnimation.fromValue = view.layer.position.y as AnyObject!
            positionAnimation.toValue = newPosition.y as AnyObject!
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            view.layer.position = newPosition
        }
        return self
    }

    public func makeCenterX(_ x: CGFloat) -> DKChainableAnimationKit {
        return self.makeX(x - view.bounds.size.width / 2)
    }

    public func makeCenterY(_ y: CGFloat) -> DKChainableAnimationKit {
        return self.makeY(y - view.bounds.size.height / 2)
    }

    public func makeWidth(_ width: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(width, self.view.layer.frame.size.height)
    }

    public func makeHeight(_ height: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(self.view.layer.frame.size.width, height)
    }

    public func makeScale(_ scale: CGFloat) -> DKChainableAnimationKit {
        let scale = max(0, scale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            scaleAnimation.fromValue = NSValue(cgRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(cgRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    public func makeScaleX(_ xScale: CGFloat) -> DKChainableAnimationKit {
        let xScale = max(0, xScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            scaleAnimation.fromValue = NSValue(cgRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(cgRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    public func makeScaleY(_ yScale: CGFloat) -> DKChainableAnimationKit {
        let yScale = max(0, yScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * yScale, 0), height: view.bounds.size.height)
            scaleAnimation.fromValue = NSValue(cgRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(cgRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * yScale, 0), height: view.bounds.size.height)
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }


    // MARK: - Move

    public func moveX(_ x: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            positionAnimation.fromValue = view.layer.position.x as AnyObject!
            positionAnimation.toValue = (view.layer.position.x + x) as AnyObject!
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.x += x
            view.layer.position = position
        }
        return self
    }

    public func moveY(_ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            positionAnimation.fromValue = view.layer.position.y as AnyObject!
            positionAnimation.toValue = (view.layer.position.y + y) as AnyObject!
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.y += y
            view.layer.position = position
        }
        return self
    }

    public func moveXY(_ x :CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let oldOrigin = view.layer.frame.origin
            let newPosition = CGPoint(x: view.layer.position.x + x, y: view.layer.position.y + y)
            positionAnimation.fromValue = NSValue(cgPoint: oldOrigin)
            positionAnimation.toValue = NSValue(cgPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.x += x
            position.y += y
            view.layer.position = position
        }
        return self
    }

    public func moveHeight(_ height: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            positionAnimation.fromValue = NSValue(cgSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(cgSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            let bounds = CGRect(origin: CGPoint.zero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func moveWidth(_ width: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            positionAnimation.fromValue = NSValue(cgSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(cgSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            let bounds = CGRect(origin: CGPoint.zero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func movePolar(_ radius: Double, _ angle: Double) -> DKChainableAnimationKit {
        let radians  = self.degreesToRadians(angle)
        let x = CGFloat(radius * cos(radians))
        let y = CGFloat(-radius * sin(radians))
        return self.moveXY(x, y)
    }
}
