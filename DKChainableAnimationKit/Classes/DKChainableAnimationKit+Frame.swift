//
//  DKChainableAnimationKit+Frame.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import Foundation

public extension DKChainableAnimationKit {

    public func makeFrame(rect: CGRect) -> DKChainableAnimationKit {
        return self.makeOrigin(rect.origin.x, rect.origin.y).makeBounds(rect)
    }

    public func makeFrame(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return self.makeOrigin(x, y).makeBounds(rect)
    }

    public func makeBounds(rect: CGRect) -> DKChainableAnimationKit {
        return self.makeSize(rect.size.width, rect.size.height)
    }

    public func makeBounds(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(width, height)
    }


    public func makeSize(width: CGFloat, _ height: CGFloat) -> DKChainableAnimationKit {

        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let sizeAnimation = self.basicAnimationForKeyPath("bounds.size")
            sizeAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            sizeAnimation.toValue = NSValue(CGSize: CGSize(width: width, height: height))
            self.addAnimationFromCalculationBlock(sizeAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var bounds = CGRect(x: 0, y: 0, width: width, height: height)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func makeOrigin(x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(CGPoint: view.layer.position)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: y))
            view.layer.position = newPosition
        }
        return self

    }

    public func makeCenter(x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let newPosition = self.newPositionFrom(newCenter: CGPoint(x: x, y: y))
            positionAnimation.fromValue = NSValue(CGPoint: view.layer.position)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.center = CGPoint(x: x, y: y)
        }
        return self
    }

    public func makeX(x: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            positionAnimation.fromValue = view.layer.position.x
            positionAnimation.toValue = newPosition.x
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: x, y: view.layer.frame.origin.y))
            view.layer.position = newPosition
        }
        return self
    }

    public func makeY(y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            positionAnimation.fromValue = view.layer.position.y
            positionAnimation.toValue = newPosition.y
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newPosition = self.newPositionFrom(newOrigin: CGPoint(x: view.layer.frame.origin.x, y: y))
            view.layer.position = newPosition
        }
        return self
    }

    public func makeCenterX(x: CGFloat) -> DKChainableAnimationKit {
        return self.makeX(x - view.bounds.size.width / 2)
    }

    public func makeCenterY(y: CGFloat) -> DKChainableAnimationKit {
        return self.makeY(y - view.bounds.size.height / 2)
    }

    public func makeWidth(width: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(width, self.view.layer.frame.size.height)
    }

    public func makeHeight(height: CGFloat) -> DKChainableAnimationKit {
        return self.makeSize(self.view.layer.frame.size.width, height)
    }

    public func makeScale(scale: CGFloat) -> DKChainableAnimationKit {
        let scale = max(0, scale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * scale, 0), height: max(view.bounds.size.height * scale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    public func makeScaleX(xScale: CGFloat) -> DKChainableAnimationKit {
        let xScale = max(0, xScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
            self.addAnimationFromCalculationBlock(scaleAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: max(view.bounds.size.height * xScale, 0))
            view.layer.bounds = rect
            view.bounds = rect
        }
        return self
    }

    public func makeScaleY(yScale: CGFloat) -> DKChainableAnimationKit {
        let yScale = max(0, yScale)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let scaleAnimation = self.basicAnimationForKeyPath("bounds")
            let rect = CGRect(x: 0, y: 0, width: max(view.bounds.size.width * yScale, 0), height: view.bounds.size.height)
            scaleAnimation.fromValue = NSValue(CGRect: view.layer.bounds)
            scaleAnimation.toValue = NSValue(CGRect: rect)
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

    public func moveX(x: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.x")
            positionAnimation.fromValue = view.layer.position.x
            positionAnimation.toValue = view.layer.position.x + x
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.x += x
            view.layer.position = position
        }
        return self
    }

    public func moveY(y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position.y")
            positionAnimation.fromValue = view.layer.position.y
            positionAnimation.toValue = view.layer.position.y + y
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            var position = view.layer.position
            position.y += y
            view.layer.position = position
        }
        return self
    }

    public func moveXY(x :CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("position")
            let oldOrigin = view.layer.frame.origin
            let newPosition = CGPoint(x: view.layer.position.x + x, y: view.layer.position.y + y)
            positionAnimation.fromValue = NSValue(CGPoint: oldOrigin)
            positionAnimation.toValue = NSValue(CGPoint: newPosition)
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

    public func moveHeight(height: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            positionAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(CGSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: view.layer.bounds.size.width, height: max(view.layer.bounds.size.width + height, 0))
            let bounds = CGRect(origin: CGPointZero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func moveWidth(width: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let positionAnimation = self.basicAnimationForKeyPath("bounds.size")
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            positionAnimation.fromValue = NSValue(CGSize: view.layer.bounds.size)
            positionAnimation.toValue = NSValue(CGSize: newSize)
            self.addAnimationFromCalculationBlock(positionAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            let newSize = CGSize(width: max(view.layer.bounds.size.width + width, 0), height: view.layer.bounds.size.height)
            let bounds = CGRect(origin: CGPointZero, size: newSize)
            view.layer.bounds = bounds
            view.bounds = bounds
        }
        return self
    }

    public func movePolar(radius: Double, _ angle: Double) -> DKChainableAnimationKit {
        let radians  = self.degreesToRadians(angle)
        let x = CGFloat(radius * cos(radians))
        let y = CGFloat(-radius * sin(radians))
        return self.moveXY(x, y)
    }
}