//
//  DKChainableAnimationKit.swift
//  DKChainableAnimationKit
//
//  Created by apple on 15/5/13.
//  Copyright (c) 2015年 DeltaX. All rights reserved.
//

import UIKit

public class DKChainableAnimationKit {

    weak var view: UIView!

    typealias AnimationCalculationAction = UIView -> Void
    typealias AnimationCompletionAction = UIView -> Void

    internal var animationCalculationActions: [[AnimationCalculationAction]]!
    internal var animationCompletionActions: [[AnimationCompletionAction]]!
    internal var animationGroups: NSMutableArray!
    internal var animations: [[DKKeyFrameAnimation]]!
    public var animationCompletion: (Void -> Void)?

    // MARK: - Initialize

    init() {
        self.setup()
    }

    private func setup() {
        self.animations = [[]]
        self.animationGroups = [self.basicAnimationGroup()]
        self.animationCompletionActions = [[]]
        self.animationCalculationActions = [[]]
    }

    private func clear() {
        self.animations.removeAll()
        self.animationGroups.removeAllObjects()
        self.animationCompletionActions.removeAll()
        self.animationCalculationActions.removeAll()
        self.animations.append([])
        self.animationCompletionActions.append([AnimationCalculationAction]())
        self.animationCalculationActions.append([AnimationCompletionAction]())
        self.animationGroups.addObject(self.basicAnimationGroup())
    }

    // MARK: - Animation Properties

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

    public func makeOpacity(opacity: CGFloat) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let opacityAnimation = self.basicAnimationForKeyPath("opacity")
            opacityAnimation.fromValue = view.alpha
            opacityAnimation.toValue = opacity
            self.addAnimationFromCalculationBlock(opacityAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.alpha = opacity
        }
        return self
    }

    public func makeBackground(color: UIColor) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let backgroundColorAnimation = self.basicAnimationForKeyPath("backgroundColor")
            backgroundColorAnimation.fromValue = view.backgroundColor
            backgroundColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(backgroundColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.backgroundColor = color
        }
        return self
    }

    public func makeBorderColor(color: UIColor) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderColor")
            borderColorAnimation.fromValue = UIColor(CGColor: view.layer.borderColor)
            borderColorAnimation.toValue = color
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderColor = color.CGColor
        }
        return self
    }

    public func makeBorderWidth(width: CGFloat) -> DKChainableAnimationKit {
        let width = max(0, width)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let borderColorAnimation = self.basicAnimationForKeyPath("borderWidth")
            borderColorAnimation.fromValue = view.layer.borderWidth
            borderColorAnimation.toValue = width
            self.addAnimationFromCalculationBlock(borderColorAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.borderWidth = width
        }
        return self
    }

    public func makeCornerRadius(cornerRadius: CGFloat) -> DKChainableAnimationKit {
        let cornerRadius = max(0, cornerRadius)
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let cornerRadiusAnimation = self.basicAnimationForKeyPath("cornerRadius")
            cornerRadiusAnimation.fromValue = view.layer.cornerRadius
            cornerRadiusAnimation.toValue = cornerRadius
            self.addAnimationFromCalculationBlock(cornerRadiusAnimation)
        }

        self.addAnimationCompletionAction { (view: UIView) -> Void in
            view.layer.cornerRadius = cornerRadius
        }
        return self
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

    // MARK: - Anchor

    private func makeAnchorFrom(#x: CGFloat, y: CGFloat) {
        let anchorPoint = CGPoint(x: x, y: y)
        func action(view: UIView) {
            if CGPointEqualToPoint(anchorPoint, view.layer.anchorPoint) {
                return
            }
            var newPoint = CGPoint(
                x: view.bounds.size.width * anchorPoint.x,
                y: view.bounds.size.height * anchorPoint.y
            )
            var oldPoint = CGPoint(
                x: view.bounds.size.width * view.layer.anchorPoint.x,
                y: view.bounds.size.height * view.layer.anchorPoint.y
            )
            newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
            oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)

            var position = view.layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            view.layer.position = position
            view.layer.anchorPoint = anchorPoint
        }

        if var lastCalculationActions = self.animationCalculationActions.last {
            lastCalculationActions.insert(action, atIndex: 0)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(lastCalculationActions)
        }
    }

    public func makeAnchor(x: CGFloat, _ y: CGFloat) -> DKChainableAnimationKit {
        self.makeAnchorFrom(x: x, y: y)
        return self
    }

    public var anchorDefault: DKChainableAnimationKit {
        get {
            return self.anchorCenter
        }
    }

    public var anchorCenter: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.5)
            return self
        }
    }

    public var anchorTopLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.0)
            return self
        }
    }

    public var anchorTopRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.0)
            return self
        }
    }

    public var anchorBottomLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 1.0)
            return self
        }
    }

    public var anchorBottomRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 1.0)
            return self
        }
    }

    public var anchorTop: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 0.0)
            return self
        }
    }

    public var anchorBottom: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.5, y: 1.0)
            return self
        }
    }

    public var anchorLeft: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 0.0, y: 0.5)
            return self
        }
    }

    public var anchorRight: DKChainableAnimationKit {
        get {
            self.makeAnchorFrom(x: 1.0, y: 0.5)
            return self
        }
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

    public func rotate(angle: Double) -> DKChainableAnimationKit {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let rotationAnimation = self.basicAnimationForKeyPath("transform.rotation")
            let transform = view.layer.transform
            let originalRotation = Double(atan2(transform.m12, transform.m11))
            rotationAnimation.fromValue = originalRotation
            rotationAnimation.toValue = originalRotation + self.degreesToRadians(angle)
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

    // MARK: - Bezier

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

    // MARK: - Animation Effects

    public var easeIn: DKChainableAnimationKit {
        get {
            self.easeInQuad
            return self
        }
    }

    public var easeOut: DKChainableAnimationKit {
        get {
            self.easeOutQuad
            return self
        }
    }

    public var easeInOut: DKChainableAnimationKit {
        get {
            self.easeInOutQuad
            return self
        }
    }

    public var easeBack: DKChainableAnimationKit {
        get {
            self.easeOutBack
            return self
        }
    }

    public var spring: DKChainableAnimationKit {
        get {
            self.easeOutElastic
            return self
        }
    }

    public var bounce: DKChainableAnimationKit {
        get { 
            self.easeOutBounce
            return self         
        }
    }

    public var easeInQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuad)
            return self
        }
    }

    public var easeOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuad)
            return self
        }
    }

    public var easeInOutQuad: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuad)
            return self
        }
    }

    public var easeInCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCubic)
            return self
        }
    }

    public var easeOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCubic)
            return self
        }
    }

    public var easeInOutCubic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCubic)
            return self
        }
    }

    public var easeInQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuart)
            return self
        }
    }

    public var easeOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuart)
            return self
        }
    }

    public var easeInOutQuart: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuart)
            return self
        }
    }

    public var easeInQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInQuint)
            return self
        }
    }

    public var easeOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutQuint)
            return self
        }
    }

    public var easeInOutQuint: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutQuint)
            return self
        }
    }

    public var easeInSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInSine)
            return self
        }
    }

    public var easeOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutSine)
            return self
        }
    }

    public var easeInOutSine: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutSine)
            return self
        }
    }

    public var easeInExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInExpo)
            return self
        }
    }

    public var easeOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutExpo)
            return self
        }
    }

    public var easeInOutExpo: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutExpo)
            return self
        }
    }

    public var easeInCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInCirc)
            return self
        }
    }

    public var easeOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutCirc)
            return self
        }
    }

    public var easeInOutCirc: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutCirc)
            return self
        }
    }

    public var easeInElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInElastic)
            return self
        }
    }

    public var easeOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutElastic)
            return self
        }
    }

    public var easeInOutElastic: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutElastic)
            return self
        }
    }

    public var easeInBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBack)
            return self
        }
    }

    public var easeOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBack)
            return self
        }
    }

    public var easeInOutBack: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBack)
            return self
        }
    }

    public var easeInBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInBounce)
            return self
        }
    }

    public var easeOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseOutBounce)
            return self
        }
    }

    public var easeInOutBounce: DKChainableAnimationKit {
        get {
            self.addAnimationKeyframeCalculation(DKKeyframeAnimationFunctionEaseInOutBounce)
            return self
        }
    }

    private func addAnimationKeyframeCalculation(functionBlock: DKKeyframeAnimationFunctionBlock) {
        self.addAnimationCalculationAction { (view: UIView) -> Void in
            let animationCluster = self.animations.first
            if let animation = animationCluster?.last {
                animation.functionBlock = functionBlock
            }
        }
    }

    // MARK: - Animation Time

    public func delay(delay: NSTimeInterval) -> DKChainableAnimationKit {
        var delay = delay
        for group in self.animationGroups {
            let duration = group.duration as NSTimeInterval
            delay += duration
        }
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.beginTime = CACurrentMediaTime() + delay
        }
        return self
    }

    public var seconds: DKChainableAnimationKit {
        get {
            return self
        }
    }

    public func wait(delay: NSTimeInterval) -> DKChainableAnimationKit {
        return self.delay(delay)
    }

    public func animate(duration: NSTimeInterval) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animateChain()
        }
        return self
    }

    public func animate(duration: CGFloat) -> DKChainableAnimationKit {
        return animate(NSTimeInterval(duration))
    }

    public func thenAfter(after: NSTimeInterval) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = after
            let newGroup = self.basicAnimationGroup()
            self.animationGroups.addObject(newGroup)
            self.animations.append([])
            self.animationCalculationActions.append([])
            self.animationCompletionActions.append([])
        }
        return self
    }

    public func thenAfter(after: CGFloat) -> DKChainableAnimationKit {
        return thenAfter(NSTimeInterval(after))
    }

    public func animateWithCompletion(duration: NSTimeInterval, _ completion: Void -> Void) -> DKChainableAnimationKit {
        if let group = self.animationGroups.lastObject as? CAAnimationGroup {
            group.duration = duration
            self.animationCompletion = completion
            self.animateChain()
        }
        return self
    }

    public func animateWithCompletion(duration: CGFloat, _ completion: Void -> Void) -> DKChainableAnimationKit {
        return animateWithCompletion(NSTimeInterval(duration), completion)
    }

    private func degreesToRadians(degree: Double) -> Double {
        return (degree / 180.0) * M_PI
    }

    private func animateChain() {
        self.sanityCheck()
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            self.view.layer.removeAnimationForKey("AnimationChain")
            self.chainLinkDidFinishAnimating()
        }
        self.animateChainLink()
        CATransaction.commit()

        self.executeCompletionActions()
    }

    private func animateChainLink() {
        self.makeAnchor(0.5, 0.5)
        if let animationCluster = self.animationCalculationActions.first {
            for action in animationCluster {
                action(self.view)
            }
        }
        if let group: CAAnimationGroup = self.animationGroups.firstObject as? CAAnimationGroup, animationCluster: [DKKeyFrameAnimation] = self.animations.first {
            for animation in animationCluster {
                animation.duration = group.duration
                animation.calculte()
            }
            group.animations = animationCluster
            self.view.layer.addAnimation(group, forKey: "AnimationChain")
        }
    }

    private func executeCompletionActions() {
        if let group = self.animationGroups.firstObject as? CAAnimationGroup {
            let delay = max(group.beginTime - CACurrentMediaTime(), 0.0)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                if let actionCluster: [AnimationCompletionAction] = self.animationCompletionActions.first {
                    for action in actionCluster {
                        action(self.view)
                    }
                }
            }
        }
    }

    private func chainLinkDidFinishAnimating() {
        self.animationCompletionActions.removeAtIndex(0)
        self.animationCalculationActions.removeAtIndex(0)
        self.animations.removeAtIndex(0)
        self.animationGroups.removeObjectAtIndex(0)

        if self.animationGroups.count == 0 {
            self.clear()
            if let completion = self.animationCompletion {
                self.animationCompletion = nil
                completion()
            }
        } else {
            self.animateChain()
        }
    }

    private func sanityCheck() {
        assert(self.animations.count == self.animationGroups.count, "FATAL ERROR: ANIMATION GROUPS AND ANIMATIONS ARE OUT OF SYNC");
        assert(self.animationCalculationActions.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATION CALCULATION OBJECTS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
        assert(self.animations.count == self.animationCompletionActions.count, "FATAL ERROR: ANIMATIONS AND ANIMATION COMPLETION OBJECTS ARE OUT OF SYNC");
    }

    // MARK: - Animation Action

    internal func addAnimationCalculationAction(action: AnimationCalculationAction) {
        if var actions = self.animationCalculationActions.last as [AnimationCalculationAction]? {
            actions.append(action)
            self.animationCalculationActions.removeLast()
            self.animationCalculationActions.append(actions)
        }
    }

    internal func addAnimationCompletionAction(action: AnimationCompletionAction) {
        if var actions = self.animationCompletionActions.last as [AnimationCompletionAction]? {
            actions.append(action)
            self.animationCompletionActions.removeLast()
            self.animationCompletionActions.append(actions)
        }
    }

    internal func addAnimationFromCalculationBlock(animation: DKKeyFrameAnimation) {
        if var animationCluster = self.animations.first {
            animationCluster.append(animation)
            self.animations.removeAtIndex(0)
            self.animations.insert(animationCluster, atIndex: 0)
        }
    }

    // MARK: - Basic Animation Helper

    internal func basicAnimationGroup() -> CAAnimationGroup {
        return CAAnimationGroup()
    }
    
    internal func basicAnimationForKeyPath(keyPath: String) -> DKKeyFrameAnimation {
        let animation = DKKeyFrameAnimation(keyPath: keyPath)
        animation.repeatCount = 0
        animation.autoreverses = false
        return animation
    }

    internal func newPositionFrom(#newOrigin: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newOrigin.x + anchor.x * size.width, y: newOrigin.y + anchor.y * size.height)
        return newPosition
    }

    internal func newPositionFrom(#newCenter: CGPoint) -> CGPoint {
        let anchor = self.view.layer.anchorPoint
        let size = self.view.bounds.size
        let newPosition = CGPoint(x: newCenter.x + (anchor.x - 0.5) * size.width, y: newCenter.y + (anchor.y - 0.5) * size.height)
        return newPosition
    }

}
